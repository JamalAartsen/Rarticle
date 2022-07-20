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
 
// TODO: Tab bar for search or automatisch zoeken naar bijvoorbeeld 1 seconde geen user interactie inplaats van enter klikken (throttle / debounce) -> property wrapper om naar te kijken
class ViewController: UIViewController {
    
    private lazy var articlesTableView: UITableView = makeTableView()
    private var alert: UIAlertController = UIAlertController()
    private lazy var titlePage: UILabel = makeTitleLabel()
    private lazy var retryButton: UIButton = makeRetryButton()
    private lazy var searchBar: UISearchBar = makeSearchBar()
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
        
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        searchBar.delegate = self
        
        retryButton.addTarget(self, action: #selector(self.retryReloadTableView), for: .touchUpInside)
        animations()
        handleDropDownSelection()
        
        articlesTableView.showSpinner(showSpinner: true)
        setupLayout()
        setupPullToRefreshTableview()
        getAllNewsArticles(topic: nil)
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

    @objc private func handleShowSearchBar() {
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
        
    private func setupLayout() {
        view.addSubview(titlePage)
        view.addSubview(articlesTableView)
        
        view.backgroundColor = Colors.backgroundArticlesScreenColor
        
        articlesTableView.estimatedRowHeight = 75
        articlesTableView.rowHeight = UITableView.automaticDimension
        
        navigationController?.navigationBar.tintColor = Colors.navigationBarColor
        
        // TODO: /////////////////////////////////////////////////////////////////////////
        let article = Article.init(description: "", title: "", url: "", urlToImage: "https://static.wikia.nocookie.net/lotr/images/9/90/Sauron-2.jpg/revision/latest?cb=20110508182634", author: "", publishedAt: "")
        let article2 = Article.init(description: "", title: "", url: "", urlToImage: nil, author: "", publishedAt: "")
        print("URL: \(article.stringToUrlConverter())")
        print("URL2: \(article2.stringToUrlConverter())")
        // TODO: ///////////////////////////////////////////////////////////////////////
        
        navigationItem.leftBarButtonItem = filterIcon
        searchBar.sizeToFit()
        showSearchBarButton(shouldShow: true)
        
        dropDown.anchorView = filterIcon
        dropDown.dataSource = [LocalizedStrings.filterTitleByAZ, LocalizedStrings.filterTitleByZA]
        
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
    
    // TODO: Topic kan misschien niet nil zijn als de gebruiker iets aan het zoeken is. Als het goed is hoeft dat niet als er een nieuwe viewcontroller komt voor search
    @objc private func retryReloadTableView() {
        articlesTableView.reloadData()
        articlesTableView.showSpinner(showSpinner: true)
        getAllNewsArticles(topic: nil)
    }
    
    private func getAllNewsArticles(topic: String?) {
        Task {
            do {
                articles = try await newsRepository.getAllNewsArticles(topic: topic).articles
                articlesTableView.showSpinner(showSpinner: false)
            }
            catch let error {
                showAlertDialog(error: error.localizedDescription)
                articlesTableView.backgroundView = retryButton
                articlesTableView.backgroundView?.easy.layout(Center())
            }
        }
    }
    
    private func showAlertDialog(error: String) {
        alert = makeAlertDialog()
        alert.message = error
        alert.addAction(UIAlertAction(title: LocalizedStrings.alertActionTitle, style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearchBar))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
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
    
    // TODO: Show something when there is no internet, laat geen error zien
    private func searchArticles(topic: String?) {
        getAllNewsArticles(topic: topic)
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        articlesTableView.deselectRow(at: indexPath, animated: true)
        
        let article = articles[indexPath.row]
    
        navigationController?.pushViewController(DetailsViewController(
            titleArticle: article.title,
            descriptionArticle: article.description,
            imageArticle: article.urlToImage,
            linkArticle: article.url,
            author: article.author,
            publishedAt: article.publishedAt
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

extension ViewController: UITableViewDataSource {
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

extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(searchText)")
        if searchText.isEmpty {
            searchArticles(topic: nil)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: This method is not triggered when internet is gone
        articlesTableView.showSpinner(showSpinner: true)
        searchArticles(topic: searchBar.text! as String)
        print("searchBarSearchButtonClickd is triggered")
    }
}

private extension ViewController {
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
    
    func makeAlertDialog() -> UIAlertController {
        let alertController = UIAlertController(title: LocalizedStrings.alertDialogTitle, message: nil, preferredStyle: .actionSheet)
        return alertController
    }
    
    func makeRetryButton() -> UIButton {
        let retryBtn = UIButton()
        retryBtn.backgroundColor = .systemBlue
        retryBtn.layer.cornerRadius = 5
        retryBtn.setTitle(LocalizedStrings.retry, for: .normal)
        return retryBtn
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
