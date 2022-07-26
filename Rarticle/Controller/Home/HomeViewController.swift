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
 
class HomeViewController: UIViewController {
    
    // MARK: Properties
    private lazy var articlesTableView: RTableView = .makeTableView(cornerRadius: 10)
    private lazy var titlePage: UILabel = makeTitleLabel()
    private lazy var retryButton: UIButton = .makeButton(backgroundColor: Colors.buttonBackgroundcolor!, cornerRadius: 5)
    private lazy var filterIcon: UIBarButtonItem = makeCustomUIBarButtonItem(iconID: Constants.filterIconID)
    private lazy var dropDown: RDropDown = .makeDropDown(cornerRadius: 5)
    private let refreshControl = UIRefreshControl()
    
    private var articles: [Article] = [] {
        didSet {
            articlesTableView.reloadData()
        }
    }
    private var pagePagination = 1
    private var dropDownIndex = 0
    
    @Injected private var newsRepository: NewsRepository
    @Injected private var sortingService: SortingService
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retryButton.addTarget(self, action: #selector(self.didTapReload), for: .touchUpInside)
        animations()
        
        setupLayout()
        setupDropDown()
        setupLocalization()
        setupNavigationController()
        setupConstraints()
        setupPullToRefreshTableview()
        getArticles(topic: nil)
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
    
    // MARK: Animations
    private func animations() {
        titlePage.alpha = 0
        articlesTableView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.titlePage.alpha = 1.0
            self.articlesTableView.alpha = 1.0
        }
    }
    
    // MARK: Get articles
    private func getArticles(topic: String? = nil, sortBy: String = Constants.publishedAt, page: Int = 1, isPagination: Bool = false) {
        articlesTableView.showSpinner(showSpinner: true)
        Task {
            do {
                let articlesAPI = try await newsRepository.getAllNewsArticles(topic: topic, sortBy: sortBy, page: page).articles
                
                articles.replaceOrAppendCurrentList(isPagination: isPagination, articles: articlesAPI)
                articlesTableView.showSpinner(showSpinner: false)
                articlesTableView.showMessage(show: articles.isEmpty, messageResult: LocalizedStrings.noResults)
            }
            
            catch let error {
                showAlertDialog(error: error.localizedDescription)
                articlesTableView.backgroundView = retryButton
                articlesTableView.backgroundView?.easy.layout(Center())
            }
        }
    }
    
    // MARK: Show alert dialog
    private func showAlertDialog(error: String) {
        let alert: RAlertDialog = .makeAlertDialog(title: LocalizedStrings.alertDialogTitle)
        alert.message = error
        alert.addAction(UIAlertAction(title: LocalizedStrings.alertActionTitle, style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    private func setupPullToRefreshTableview() {
        refreshControl.attributedTitle = NSAttributedString(string: "Loading articles")
        refreshControl.addTarget(self, action: #selector(didTapRefresh(_:)), for: .valueChanged)
        articlesTableView.addSubview(refreshControl)
    }
}

// MARK: UITabkeViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        articlesTableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
    
        didSelectCell(article: article)
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

        if distanceFromBottom < height {
            pagePagination += 1
            getArticles(topic: nil, sortBy: sortingService.sortBy(index: dropDownIndex), page: pagePagination, isPagination: true)
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
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    @objc private func didTapReload() {
        // TODO: Wanneer de gebruiker sorting preference opgeslagen wordt moet die hier gegeven worden bij sortingService.sortBy(index: Int)
        getArticles(topic: nil)
    }
    
    @objc private func didTapFilter() {
        dropDown.show()
    }
    
    // TODO: 
    @objc private func didTapRefresh(_ sender: AnyObject) {
        print("Refresh data")
    }
    
    @objc private func didSelectDropDownItem(index: Int) {
        dropDownIndex = index
        pagePagination = 1
        getArticles(topic: nil, sortBy: sortingService.sortBy(index: index))
    }
    
    private func didSelectCell(article: Article) {
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
