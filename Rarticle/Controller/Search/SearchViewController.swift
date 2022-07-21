//
//  SearchViewController.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 20/07/2022.
//

import Foundation
import UIKit
import EasyPeasy
import Resolver

class SearchViewController: UIViewController {
    
    private lazy var searchArticlesTableView: UITableView = makeTableView()
    private lazy var searchBar: UISearchBar = makeSearchBar()
    private lazy var retryButton: UIButton = .makeButton(backgroundColor: Colors.buttonBackgroundcolor!, cornerRadius: 5, title: LocalizedStrings.retry)
    private lazy var alert: RAlertDialog = RAlertDialog()
    
    var articles: [Article] = [] {
        didSet {
            searchArticlesTableView.reloadData()
        }
    }
    
    @Injected var newsRepository: NewsRepository
    
    override func viewDidLoad() {
        setupLayout()
        setupConstraints()
        setUpNavigationController()
    }
    
    private func getArticlesByTopic(topic: String?) {
        Task {
            do {
                articles = try await newsRepository.getAllNewsArticles(topic: topic).articles
                searchArticlesTableView.showSpinner(showSpinner: false)
                searchArticlesTableView.showMessage(show: articles.isEmpty, messageResult: LocalizedStrings.noResults)
            }
            catch let error {
                // TODO: Wanneer de home tableview alle articles laat zien en daarna offline gaat en iets search worden de errors niet weergegeven
                searchArticlesTableView.backgroundView = retryButton
                searchArticlesTableView.backgroundView?.easy.layout(Center())
                showAlertDialog(error: error.localizedDescription)
            }
        }
    }
    
    private func setupConstraints() {
        searchArticlesTableView.easy.layout(
            Top(0).to(view, .topMargin),
            Bottom(0),
            Right(0),
            Left(0)
        )
        
        retryButton.easy.layout(Width(100))
    }
    
    private func setupLayout() {
        searchArticlesTableView.delegate = self
        searchArticlesTableView.dataSource = self
        searchBar.delegate = self
        
        view.backgroundColor = Colors.backgroundArticlesScreenColor
        view.addSubview(searchArticlesTableView)
        
        searchBar.sizeToFit()
        searchBar.becomeFirstResponder()
        //TODO: make one object of LocalizedStrings(This is for all viewcontrollers)
        searchBar.placeholder = LocalizedStrings.placeholderSearch
        
        searchArticlesTableView.estimatedRowHeight = 75
        searchArticlesTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setUpNavigationController() {
        let backButtonImage = UIImage(named: Constants.backButtonID)
        let backItem = UIBarButtonItem()
        let navigationBar = navigationController?.navigationBar
        
        navigationController?.navigationBar.tintColor = Colors.navigationBarColor
        navigationItem.titleView = searchBar
        
        navigationBar?.backIndicatorImage = backButtonImage
        navigationBar?.backIndicatorTransitionMaskImage = backButtonImage
        
        backItem.title = LocalizedStrings.articles
        navigationBar?.topItem?.backBarButtonItem = backItem
    }
    
    private func showAlertDialog(error: String) {
        alert = .makeAlertDialog(title: LocalizedStrings.alertDialogTitle)
        alert.message = error
        alert.addAction(UIAlertAction(title: LocalizedStrings.alertActionTitle, style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func retryReloadTableView() {
        searchArticlesTableView.showSpinner(showSpinner: true)
        getArticlesByTopic(topic: nil)
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchArticlesTableView.deselectRow(at: indexPath, animated: true)
        
        let article = articles[indexPath.row]
    
        navigationController?.pushViewController(DetailsViewController(
            titleArticle: article.title,
            descriptionArticle: article.description,
            imageArticle: article.urlToImage,
            linkArticle: article.url,
            author: article.author,
            publishedAt: article.publishedAt,
            backButtonTitle: LocalizedStrings.searchResults
        ), animated: true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let articleCell = searchArticlesTableView.cellForRow(at: indexPath) {
            articleCell.backgroundColor = .gray
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let articleCell = searchArticlesTableView.cellForRow(at: indexPath) {
            articleCell.backgroundColor = Colors.cellColor
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let articleCell = tableView.dequeueReusableCell(withIdentifier: Constants.articleCellIndentifier, for: indexPath) as? ArticleCell {
            if let article = articles[safe: indexPath.row] {
                articleCell.updateCellView(article: article)
            }
            articleCell.backgroundColor = Colors.cellColor
            articleCell.accessoryType = .disclosureIndicator
            return articleCell
        } else {
            return ArticleCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row)) {
            cell.alpha = 1
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getArticlesByTopic(topic: searchBar.text)
        searchArticlesTableView.showSpinner(showSpinner: true)
    }
}

private extension SearchViewController {
    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(ArticleCell.self, forCellReuseIdentifier: Constants.articleCellIndentifier)
        
        return tableView
    }
    
    func makeSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        
        return searchBar
    }
}
