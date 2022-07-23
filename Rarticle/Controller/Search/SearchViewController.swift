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
    
    // MARK: Properties
    private lazy var searchArticlesTableView: RTableView = .makeTableView()
    private lazy var searchBar: UISearchBar = makeSearchBar()
    private lazy var retryButton: UIButton = .makeButton(backgroundColor: Colors.buttonBackgroundcolor!, cornerRadius: 5, title: LocalizedStrings.retry)
    private lazy var faButton: UIButton = makeFloatingActionButton()
    
    private var articles: [Article] = [] {
        didSet {
            searchArticlesTableView.reloadData()
        }
    }
    private var searchTopic: String? = nil
    
    @Injected private var newsRepository: NewsRepository
    @Injected private var sortingService: SortingService
    
    override func viewDidLoad() {
        setupLayout()
        setupConstraints()
        setUpNavigationController()
        
        retryButton.addTarget(self, action: #selector(self.didTapReload), for: .touchUpInside)
    }
    
    // MARK: Get Articles
    private func getArticlesByTopic(topic: String?, sortBy: String) {
        searchArticlesTableView.showSpinner(showSpinner: true)
        Task {
            do {
                articles = try await newsRepository.getAllNewsArticles(topic: topic, sortBy: sortBy).articles
                searchArticlesTableView.showSpinner(showSpinner: false)
                searchArticlesTableView.showMessage(show: articles.isEmpty, messageResult: LocalizedStrings.noResults)
            }
            catch let error {
                // TODO: Catch word niet getriggered als de internet weg valt na dat alle artikelen al geladen zijn in de HomeViewController. Doe het volgende om dit te laten gebeuren: Run de app -> Laat alle artikelen laden in de HomeViewController -> Doe het internet uit -> Ga naar SearchViewController -> Typ een topic in en klik op zoeken (Enter op emulator). Deze catch wordt wel getriggered als je het volgende doet: Run de app zonder internet -> Ga naar SearchViewController -> Typ een topic in en klik op zoeken (Enter op emulator)
                searchArticlesTableView.backgroundView = retryButton
                searchArticlesTableView.backgroundView?.easy.layout(Center())
                showAlertDialog(error: error.localizedDescription)
            }
        }
    }
    
    // MARK: Setup constraints
    private func setupConstraints() {
        searchArticlesTableView.easy.layout(
            Top(0).to(view, .topMargin),
            Bottom(0),
            Right(0),
            Left(0)
        )
        
        retryButton.easy.layout(Width(100))
        faButton.easy.layout(
            Width(60),
            Height(60),
            Bottom(16),
            Right(16)
        )
    }
    
    // MARK: Show alert dialog
    private func showAlertDialog(error: String) {
        let alert: RAlertDialog = .makeAlertDialog(title: LocalizedStrings.alertDialogTitle)
        alert.message = error
        alert.addAction(UIAlertAction(title: LocalizedStrings.alertActionTitle, style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: User actions
    @objc private func didTapReload() {
        // TODO: Wanneer de retry functie is toegevoegd aan de SearchViewController moet hieronder een topic gegeven worden die de gebruiker gegeven heeft zodat de artikelen geladen worden die de gebruiker wilt. Hiervoor zou NSUserDefaults gebruikt kunnen worden.
        getArticlesByTopic(topic: searchTopic, sortBy: sortingService.sortBy())
    }
    
}

// MARK: UITableViewDelegate
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

// MARK: UITableViewDataSource
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

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTopic = searchBar.text
        getArticlesByTopic(topic: searchBar.text, sortBy: sortingService.sortBy())
    }
}

// MARK: Factory
private extension SearchViewController {    
    func makeSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        
        return searchBar
    }
    
    func makeFloatingActionButton() -> UIButton {
        let faButton = UIButton()
        faButton.layer.masksToBounds = true
        faButton.layer.cornerRadius = 30
        faButton.backgroundColor = Colors.buttonBackgroundcolor
        
        return faButton
    }
}

// MARK: Setup
private extension SearchViewController {
    private func setupLayout() {
        searchArticlesTableView.delegate = self
        searchArticlesTableView.dataSource = self
        searchBar.delegate = self
        
        view.backgroundColor = Colors.backgroundArticlesScreenColor
        view.addSubview(searchArticlesTableView)
        view.addSubview(faButton)
        
        searchBar.sizeToFit()
        searchBar.becomeFirstResponder()
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
}
