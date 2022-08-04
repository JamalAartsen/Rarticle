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

protocol ISearchViewController {
    func display(articles: [ArticleCell.ViewModel])
    func displayError(message: String)
    func displayPaginationSpinner()
}

class SearchViewController: UIViewController {
    
    // MARK: Properties
    private lazy var searchArticlesTableView: RTableView = .makeTableView()
    private lazy var searchBar: UISearchBar = makeSearchBar()
    private lazy var retryButton: UIButton = .makeButton(backgroundColor: Colors.buttonBackgroundcolor!, cornerRadius: 5)
    private lazy var faButton: UIButton = makeFloatingActionButton()
    private lazy var dropDown: RDropDown = .makeDropDown(cornerRadius: 5)
    
    private var articles: [ArticleCell.ViewModel] = []
    private var searchInteractor: SearchInteractor?
    
    init(router: SearchRouter) {
        super.init(nibName: nil, bundle: nil)
        self.searchInteractor = SearchInteractor(searchPresenter: SearchPresenter(searchViewController: self), router: router)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupLayout()
        setupConstraints()
        setUpNavigationController()
        setupDropDown()
        setupLocalization()
        buttonClicks()
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
        
        didSelectCell(articleID: article.id)
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
        
        if indexPath.row == searchArticlesTableView.lastItem().row {
            searchInteractor?.handleDidScrollToLastCell()
        }
        
        if let articleCell = tableView.dequeueReusableCell(withIdentifier: Constants.articleCellIndentifier, for: indexPath) as? ArticleCell {
            if let article = articles[safe: indexPath.row] {
                articleCell.updateCellView(viewModel: article)
            }
            articleCell.backgroundColor = Colors.cellColor
            articleCell.accessoryType = .disclosureIndicator
            return articleCell
        } else {
            return ArticleCell()
        }
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchInteractor?.handleInitialize(topic: searchBar.text)
        self.searchArticlesTableView.showSpinner(showSpinner: true)
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
        searchInteractor?.handleDidTapReload()
    }
    
    @objc func didTapFilter() {
        dropDown.show()
    }
    
    @objc func didSelectDropDownItem(index: Int) {
        // TODO: Dit mag
        searchInteractor?.handleDidTapDropdownItem(sortIndex: index)
    }
    
    func didSelectCell(articleID: String) {
        searchInteractor?.handleTapArticle(articleID: articleID)
    }
}

extension SearchViewController: ISearchViewController {
    func display(articles: [ArticleCell.ViewModel]) {
        self.articles = articles
        
        DispatchQueue.main.async {
            self.searchArticlesTableView.showSpinner(showSpinner: false)
            // TODO: Localizations moeten in interactor. Je wilt het doorgeven via je de interactor
            self.searchArticlesTableView.showMessage(show: articles.isEmpty, messageResult: LocalizedStrings.noResults)
            self.searchArticlesTableView.tableFooterView = nil
            self.searchArticlesTableView.reloadData()
        }
    }
    
    func displayError(message: String) {
        DispatchQueue.main.async {
            self.showAlertDialog(error: message)
            self.searchArticlesTableView.backgroundView = self.retryButton
            self.searchArticlesTableView.backgroundView?.easy.layout(Center())
            self.searchArticlesTableView.tableFooterView = nil
        }
    }
    
    func displayPaginationSpinner() {
        searchArticlesTableView.tableFooterView = .makeFooterSpinner(view: searchArticlesTableView.plainView)
    }
}
