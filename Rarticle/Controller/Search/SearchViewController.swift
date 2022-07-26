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
import DropDown

class SearchViewController: UIViewController {
    
    // MARK: Properties
    private lazy var searchArticlesTableView: RTableView = .makeTableView()
    private lazy var searchBar: UISearchBar = makeSearchBar()
    private lazy var retryButton: UIButton = .makeButton(backgroundColor: Colors.buttonBackgroundcolor!, cornerRadius: 5)
    private lazy var faButton: UIButton = makeFloatingActionButton()
    private lazy var dropDown: RDropDown = .makeDropDown(cornerRadius: 5)
    
    private var articles: [Article] = [] {
        didSet {
            searchArticlesTableView.reloadData()
        }
    }
    private var searchTopic: String? = nil
    private var pagePagination = 1
    private var dropDownIndex = 0
    
    @Injected private var newsRepository: NewsRepository
    @Injected private var sortingService: SortingService
    
    override func viewDidLoad() {
        setupLayout()
        setupConstraints()
        setUpNavigationController()
        setupDropDown()
        setupLocalization()
        buttonClicks()
    }
    
    // MARK: Get Articles
    private func getArticlesByTopic(topic: String?, sortBy: String = Constants.publishedAt, page: Int = 1, isPagination: Bool = false) {
        searchArticlesTableView.showSpinner(showSpinner: true)
        Task {
            do {
                let articlesAPI = try await newsRepository.getAllNewsArticles(topic: topic, sortBy: sortBy, page: page).articles
                
                articles.replaceOrAppendCurrentList(isPagination: isPagination, articles: articlesAPI)
                searchArticlesTableView.showSpinner(showSpinner: false)
                searchArticlesTableView.showMessage(show: articles.isEmpty, messageResult: LocalizedStrings.noResults)
            }
            catch let error {
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
            Bottom(32),
            Right(32)
        )
    }
    
    // MARK: Button clicks
    private func buttonClicks() {
        retryButton.addTarget(self, action: #selector(self.didTapReload), for: .touchUpInside)
        faButton.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)
    }
    
    // MARK: Show alert dialog
    private func showAlertDialog(error: String) {
        let alert: RAlertDialog = .makeAlertDialog(title: LocalizedStrings.alertDialogTitle)
        alert.message = error
        alert.addAction(UIAlertAction(title: LocalizedStrings.alertActionTitle, style: .default))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchArticlesTableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
    
        didSelectCell(article: article)
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
//        cell.alpha = 0
//
//        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row)) {
//            cell.alpha = 1
//        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        guard !self.articles.isEmpty else { return }

        if distanceFromBottom < height {
            pagePagination += 1
            getArticlesByTopic(topic: searchTopic, sortBy: sortingService.sortBy(index: dropDownIndex), page: pagePagination, isPagination: true)
        }
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTopic = searchBar.text
        getArticlesByTopic(topic: searchBar.text)
    }
}

// MARK: Factory
private extension SearchViewController {    
    func makeSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        
        return searchBar
    }
    
    func makeFloatingActionButton() -> UIButton {
        let faButton = UIButton(type: .custom)
        let image = UIImage(named: Constants.filterIconID)
        faButton.layer.cornerRadius = 30
        faButton.backgroundColor = Colors.buttonBackgroundcolor
        
        faButton.setImage(image, for: .normal)
        faButton.tintColor = .white
        faButton.layer.shadowRadius = 10
        faButton.layer.shadowOpacity = 0.3
        
        return faButton
    }
}

// MARK: Setup
private extension SearchViewController {
    func setupLayout() {
        searchArticlesTableView.delegate = self
        searchArticlesTableView.dataSource = self
        searchBar.delegate = self
        
        view.backgroundColor = Colors.backgroundArticlesScreenColor
        view.addSubview(searchArticlesTableView)
        view.addSubview(faButton)
        
        searchBar.sizeToFit()
        searchBar.becomeFirstResponder()
        
        searchArticlesTableView.estimatedRowHeight = 75
        searchArticlesTableView.rowHeight = UITableView.automaticDimension
    }
    
    func setUpNavigationController() {
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
    
    func setupDropDown() {
        dropDown.anchorView = faButton
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard !(self?.articles.isEmpty)! else { return }
            self?.didSelectDropDownItem(index: index)
        }
    }
    
    func setupLocalization() {
        retryButton.setTitle(LocalizedStrings.retry, for: .normal)
        searchBar.placeholder = LocalizedStrings.placeholderSearch
        dropDown.dataSource = [LocalizedStrings.sortByNewest, LocalizedStrings.sortByPopularity, LocalizedStrings.sortByRelevancy]
    }
}

// MARK: User actions
private extension SearchViewController {
    @objc func didTapReload() {
        getArticlesByTopic(topic: searchTopic)
    }
    
    @objc func didTapFilter() {
        dropDown.show()
    }
    
    @objc func didSelectDropDownItem(index: Int) {
        dropDownIndex = index
        pagePagination = 1
        getArticlesByTopic(topic: searchTopic, sortBy: sortingService.sortBy(index: index))
    }
    
    func didSelectCell(article: Article) {
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
}
