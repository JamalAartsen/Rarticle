//
//  ViewController.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 04/07/2022.
//

import UIKit
import EasyPeasy
import Resolver

// TODO: DARK/LIGHT MODE
class ViewController: UIViewController {
    
    private let fakeData = {[
        Article(summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas volutpat justo nec justo feugiat feugiat. Vivamus in pulvinar metus. Suspendisse quis fermentum magna. ", title: "Hallo", link: "", media: ""),
        Article(summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas volutpat justo nec justo feugiat feugiat. Vivamus in pulvinar metus. Suspendisse quis fermentum magna. ", title: "Hallo", link: "", media: ""),
        Article(summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas volutpat justo nec justo feugiat feugiat. Vivamus in pulvinar metus. Suspendisse quis fermentum magna. ", title: "Hallo", link: "", media: "")
    ]}
    
    private let articlesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ArticleCell.self, forCellReuseIdentifier: Constants.articleCellIndentifier)
        return tableView
    }()
    
    private let alert = UIAlertController(title: LocalizedStrings.alertDialogTitle, message: nil, preferredStyle: .alert)
    
    private let titlePage: UILabel = {
        let titlePage = UILabel()
        titlePage.text = LocalizedStrings.appTitle
        titlePage.font = .systemFont(ofSize: 30, weight: .bold)
        return titlePage
    } ()
    
    var articles: [Article] = [] {
        didSet {
            articlesTableView.reloadData()
        }
    }
    @Injected var newsRepository: NewsRepository
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sub views
        view.addSubview(titlePage)
        view.addSubview(articlesTableView)
        
        // TODO: Constants class for colors
        let lightGray = UIColor(hex: 0xF1F1F1)
        view.backgroundColor = lightGray
        
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        
        navigationController?.view.backgroundColor = .orange
        
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
    }
    
    private func tableViewSpinner() {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        articlesTableView.backgroundView = spinner
    }
    
    private func getAllNewsArticles() {
        Task {
            do {
                articles = try await newsRepository.getAllNewsArticles().articles
            }
            catch let error {
                print(error.localizedDescription)
                showAlertDialog(error: error.localizedDescription)
                articles = fakeData()
            }
        }
    }
    
    private func showAlertDialog(error: String) {
        alert.message = error
        alert.addAction(UIAlertAction(title: LocalizedStrings.alertActionTitle, style: .default))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped on index: \(indexPath.row)")
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
            articleCell.backgroundColor = .white
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
            articleCell.accessoryType = .disclosureIndicator
            return articleCell
        } else {
            return ArticleCell()
        }
    }
}

// In de map extensions
extension Array {
    subscript(safe index: Int) -> Element? {
        if (index < 0 || index >= count) {
            return nil
        } else {
            return self[index]
        }
    }
}
