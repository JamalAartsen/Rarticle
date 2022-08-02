//
//  ViewController.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 04/07/2022.
//

import UIKit
import EasyPeasy
import Resolver
import DropDown

protocol IHomeViewController {
    func display(articles: [ArticleCell.ViewModel])
    func displayError(message: String)
    func displayPaginationSpinner()
}
 
class HomeViewController: UIViewController {
    
    // MARK: Properties
    private lazy var articlesTableView: RTableView = .makeTableView(cornerRadius: 10)
    private lazy var titlePage: UILabel = makeTitleLabel()
    private lazy var retryButton: UIButton = .makeButton(backgroundColor: Colors.buttonBackgroundcolor!, cornerRadius: 5)
    private lazy var filterIcon: UIBarButtonItem = makeCustomUIBarButtonItem(iconID: Constants.filterIconID)
    private lazy var dropDown: RDropDown = .makeDropDown(cornerRadius: 5)
    private let refreshControl = UIRefreshControl()
    
    private var articles: [ArticleCell.ViewModel] = []
    
    @Injected private var newsRepository: NewsRepository
    private var homeInteractor: IHomeInteractor?
    
    init(router: HomeRouter) {
        super.init(nibName: nil, bundle: nil)
        self.homeInteractor = HomeInteractor(homePresenter: HomePresenter(homeViewController: self), router: router)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animations()
        setupLayout()
        setupDropDown()
        setupLocalization()
        setupNavigationController()
        setupConstraints()
        setupPullToRefreshTableview()
        buttonClicks()
        homeInteractor?.handleInitialize()
    }
    
    // MARK: Setup constraints
    private func setupConstraints() {
        articlesTableView.easy.layout([
            Top(8).to(titlePage),
            Bottom(0),
            Right(16),
            Left(16)
        ])
        
        titlePage.easy.layout([
            Top().to(view, .topMargin),
            Left(16)
        ])
        
        retryButton.easy.layout(Width(100))
        filterIcon.customView?.easy.layout(Size(24))
    }
    
    // MARK: Button clicks
    private func buttonClicks() {
        retryButton.addTarget(self, action: #selector(self.didTapReload), for: .touchUpInside)
    }
    
    // MARK: Animations
    private func animations() {
        titlePage.alpha = 0
        articlesTableView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.titlePage.alpha = 1.0
            self.articlesTableView.alpha = 1.0
        }
    }
    
    // MARK: Show alert dialog
    private func showAlertDialog(error: String) {
        let alert: RAlertDialog = .makeAlertDialog(title: LocalizedStrings.alertDialogTitle)
        alert.message = error
        alert.addAction(UIAlertAction(title: LocalizedStrings.alertActionTitle, style: .default))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: UITabkeViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        articlesTableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        print("Article selected: \(article.title)")
    
        //didSelectCell(article: article)
    }
        
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let articleCell = articlesTableView.cellForRow(at: indexPath) {
            articleCell.backgroundColor = .gray
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let articleCell = articlesTableView.cellForRow(at: indexPath) {
            articleCell.backgroundColor = Colors.cellColor
        }
    }
}

// MARK: UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == articlesTableView.lastItem().row {
            homeInteractor?.handleDidScrollToLastCell()
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

// MARK: Setup
private extension HomeViewController {
    private func setupLayout() {
        view.addSubview(titlePage)
        view.addSubview(articlesTableView)
        view.backgroundColor = Colors.backgroundArticlesScreenColor
        
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        
        articlesTableView.estimatedRowHeight = 75
        articlesTableView.rowHeight = UITableView.automaticDimension
        articlesTableView.showSpinner(showSpinner: true)
    }
    
    private func setupDropDown() {
        dropDown.anchorView = filterIcon
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            // TODO: Enum mee geven + word een domein model + dit pas doen na workshop van Kevin
            self?.didSelectDropDownItem(index: index)
        }
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.tintColor = Colors.navigationBarColor
        
        navigationItem.leftBarButtonItem = filterIcon
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    private func setupLocalization() {
        retryButton.setTitle(LocalizedStrings.retry, for: .normal)
        dropDown.dataSource = [LocalizedStrings.sortByNewest, LocalizedStrings.sortByPopularity, LocalizedStrings.sortByRelevancy]
        titlePage.text = LocalizedStrings.appTitle
    }
    
    
    private func setupPullToRefreshTableview() {
        refreshControl.attributedTitle = NSAttributedString(string: LocalizedStrings.loadingArticles)
        refreshControl.addTarget(self, action: #selector(didTapRefresh(_:)), for: .valueChanged)
        articlesTableView.addSubview(refreshControl)
    }
}

// MARK: Factory
private extension HomeViewController {
    
    func makeTitleLabel() -> UILabel {
        let titlePage = UILabel()
        titlePage.font = .systemFont(ofSize: 30, weight: .bold)
        return titlePage
    }
    
    func makeCustomUIBarButtonItem(iconID: String) -> UIBarButtonItem {
        let filterButton = UIButton(type: .custom)
        filterButton.setImage(UIImage(named: iconID), for: .normal)
        filterButton.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)
        
        return UIBarButtonItem(customView: filterButton)
    }
}

// MARK: User actions
private extension HomeViewController {
    @objc private func didTapSearch() {
        homeInteractor?.handleDidTapSearch()
    }
    
    @objc private func didTapReload() {
        homeInteractor?.handleDidTapReload()
    }

    @objc private func didTapFilter() {
        dropDown.show()
    }

    @objc private func didTapRefresh(_ sender: AnyObject) {
        homeInteractor?.handleDidTapRefresh()
    }

    @objc private func didSelectDropDownItem(index: Int) {
        homeInteractor?.handleDidTapDropdownItem(sortIndex: index)
    }
    
    private func didSelectCell(article: ArticleEntity) {
        navigationController?.pushViewController(DetailsViewController(
            titleArticle: article.title,
            descriptionArticle: article.description,
            imageArticle: article.urlToImage,
            linkArticle: article.url,
            author: article.author,
            publishedAt: article.publishedAt,
            backButtonTitle: LocalizedStrings.articles
        ), animated: true)
    }
}

extension HomeViewController: IHomeViewController {
    func display(articles: [ArticleCell.ViewModel]) {
        self.articles = articles
        for article in articles {
            print("Title: \(article.title); Image URL: \(article.image)")
        }
        DispatchQueue.main.async {
            self.articlesTableView.showSpinner(showSpinner: false)
            self.articlesTableView.showMessage(show: articles.isEmpty, messageResult: LocalizedStrings.noResults)
            self.articlesTableView.tableFooterView = nil
            self.refreshControl.endRefreshing()
            self.articlesTableView.reloadData()
            print("Spinning end.")
        }
    }
    
    func displayError(message: String) {
        DispatchQueue.main.async {
            self.showAlertDialog(error: message)
            self.articlesTableView.backgroundView = self.retryButton
            self.articlesTableView.backgroundView?.easy.layout(Center())
            self.articlesTableView.tableFooterView = nil
            self.refreshControl.endRefreshing()
        }
    }
    
    func displayPaginationSpinner() {
        articlesTableView.tableFooterView = .makeFooterSpinner(view: articlesTableView.plainView)
        print("Spinning...")
    }
}
