//
//  ViewController.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 04/07/2022.
//

import UIKit
import EasyPeasy
import Resolver
import SwiftUI

// TODO: DARK/LIGHT MODE
class ViewController: UIViewController {
    
    private lazy var articlesTableView: UITableView = makeTableView()
    private var alert: UIAlertController = UIAlertController()
    private lazy var titlePage: UILabel = makeTitleLabel()
    private lazy var retryButton: UIButton = makeRetryButton()
    
    var articles: [Article] = [] {
        didSet {
            articlesTableView.reloadData()
        }
    }
    
    @Injected var newsRepository: NewsRepository
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.addSubview(titlePage)
        view.addSubview(articlesTableView)
        
        view.backgroundColor = Colors.backgroundArticlesScreenColor
        
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        
        retryButton.addTarget(self, action: #selector(self.retryReloadTableView), for: .touchUpInside)
        animations()
        
        tableViewSpinner()
        setupLayout()
        getAllNewsArticles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
        
    private func setupLayout() {
        articlesTableView.easy.layout([
            Top(8).to(titlePage),
            Bottom(0),
            Right(16),
            Left(16)
        ])
        
        titlePage.easy.layout([
            Top(50),
            Left(16)
        ])
        
        retryButton.easy.layout(Width(100))
    }
    
    private func animations() {
        titlePage.alpha = 0
        articlesTableView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.titlePage.alpha = 1.0
            self.articlesTableView.alpha = 1.0
        }
    }
    
    private func tableViewSpinner() {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        articlesTableView.backgroundView = spinner
    }
    
    @objc private func retryReloadTableView() {
        articlesTableView.reloadData()
        tableViewSpinner()
        getAllNewsArticles()
    }
    
    private func getAllNewsArticles() {
        Task {
            do {
                // TODO: Check if data is empty (only when hardcoded data)
                //articles = try await newsRepository.getAllNewsArticles().articles
                articles = DummyData.fakeData()
                articlesTableView.backgroundView = nil
            }
            catch let error {
                print(error.localizedDescription)
                print(error)
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
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        articlesTableView.deselectRow(at: indexPath, animated: true)
        
        let article = articles[indexPath.row]
    
        navigationController?.pushViewController(DetailsViewController(
            titleArticle: article.title,
            summaryArticle: article.summary,
            imageArticle: article.media,
            linkArticle: article.link
        ), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: Automatic cell sizing tableview -> extra opdracht -> Constraints moeten wel goed zijn
        return 75
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
}
