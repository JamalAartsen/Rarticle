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
    
    private lazy var articlesTableView: UITableView = makeTableView()
    private var alert: RAlertDialog = RAlertDialog()
    private lazy var titlePage: UILabel = makeTitleLabel()
    private lazy var retryButton: UIButton = .makeButton(backgroundColor: Colors.buttonBackgroundcolor!, cornerRadius: 5, title: LocalizedStrings.retry)
    private lazy var filterIcon: UIBarButtonItem = makeCustomUIBarButtonItem(iconID: Constants.filterIconID)
    
    let dropDown = DropDown()
    let refreshControl = UIRefreshControl()
    
    var articles: [Article] = [] {
        didSet {
            articlesTableView.reloadData()
        }
    }
    
    @Injected var newsRepository: NewsRepository
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retryButton.addTarget(self, action: #selector(self.retryReloadTableView), for: .touchUpInside)
        animations()
        handleDropDownSelection()
        
        articlesTableView.showSpinner(showSpinner: true)
        setupLayout()
        setupNavigationController()
        setupConstraints()
        setupPullToRefreshTableview()
        getAllNewsArticles(topic: nil)
    }
        
    private func setupLayout() {
        view.addSubview(titlePage)
        view.addSubview(articlesTableView)
        
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
    
        articlesTableView.estimatedRowHeight = 75
        articlesTableView.rowHeight = UITableView.automaticDimension
        
        // TODO: /////////////////////////////////////////////////////////////////////////
        let article = Article.init(description: "", title: "", url: "", urlToImage: "https://static.wikia.nocookie.net/lotr/images/9/90/Sauron-2.jpg/revision/latest?cb=20110508182634", author: "", publishedAt: "")
        let article2 = Article.init(description: "", title: "", url: "", urlToImage: nil, author: "", publishedAt: "")
        print("URL: \(article.stringToUrlConverter())")
        print("URL2: \(article2.stringToUrlConverter())")
        // TODO: ///////////////////////////////////////////////////////////////////////
        
        dropDown.anchorView = filterIcon
        dropDown.dataSource = [LocalizedStrings.filterTitleByAZ, LocalizedStrings.filterTitleByZA]
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.tintColor = Colors.navigationBarColor
        
        navigationItem.leftBarButtonItem = filterIcon
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchIcon))
    }
    
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
    
    private func animations() {
        titlePage.alpha = 0
        articlesTableView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.titlePage.alpha = 1.0
            self.articlesTableView.alpha = 1.0
        }
    }
    
    @objc private func handleSearchIcon() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    @objc private func retryReloadTableView() {
        articlesTableView.showSpinner(showSpinner: true)
        getAllNewsArticles(topic: nil)
    }
    
    private func getAllNewsArticles(topic: String?) {
        Task {
            do {
                articles = try await newsRepository.getAllNewsArticles(topic: topic).articles
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
    
    private func showAlertDialog(error: String) {
        alert = .makeAlertDialog(title: LocalizedStrings.alertDialogTitle)
        alert.message = error
        alert.addAction(UIAlertAction(title: LocalizedStrings.alertActionTitle, style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func handleFilterIcon() {
        dropDown.show()
    }
    
    private func handleDropDownSelection() {
        dropDown.selectionAction = { (index: Int, item: String) in
            self.articles = self.articles.sortingByTitle(index: index)
//            switch index {
//            case 0:
//                self.articles = self.articles.sorting(by: Array<Article>.SortingType.TITLE)
//            case 1:
//                self.articles.sorting(by: Array<Article>.SortingType.DATE)
//            default:
//                print("")
//            }
        }
    }
    
    // TODO:
    private func setupPullToRefreshTableview() {
        refreshControl.attributedTitle = NSAttributedString(string: "Loading articles")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        articlesTableView.addSubview(refreshControl)
    }
    
    // TODO: 
    @objc func refresh(_ sender: AnyObject) {
        print("Refresh data")
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        articlesTableView.deselectRow(at: indexPath, animated: true)
        
        let article = articles[indexPath.row]
    
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
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row)) {
            cell.alpha = 1
        }
    }
}

private extension HomeViewController {
    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 10
        tableView.register(ArticleCell.self, forCellReuseIdentifier: Constants.articleCellIndentifier)
        return tableView
    }
    
    func makeTitleLabel() -> UILabel {
        let titlePage = UILabel()
        titlePage.text = LocalizedStrings.appTitle
        titlePage.font = .systemFont(ofSize: 30, weight: .bold)
        return titlePage
    }
    
    func makeSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        
        return searchBar
    }
    
    func makeCustomUIBarButtonItem(iconID: String) -> UIBarButtonItem {
        let filterButton = UIButton(type: .custom)
        filterButton.setImage(UIImage(named: iconID), for: .normal)
        filterButton.addTarget(self, action: #selector(handleFilterIcon), for: .touchUpInside)
        
        return UIBarButtonItem(customView: filterButton)
    }
}
