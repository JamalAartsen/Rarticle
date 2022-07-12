//
//  ViewController.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 04/07/2022.
//

import UIKit
import EasyPeasy
import Resolver

class ViewController: UIViewController {
    
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
    
    var articles: [Article] = []
    @Injected var newsRepository: NewsRepository
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sub views
        view.addSubview(titlePage)
        view.addSubview(articlesTableView)
        
        let lightGray = UIColor(hex: 0xF1F1F1)
        view.backgroundColor = lightGray
        
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        
        tableViewSpinner()
        setupLayout()
        getAllNewsArticles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupLayout() {
        articlesTableView.easy.layout([
            // Is now under statusbar
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
                self.articlesTableView.reloadData()
            }
            catch let error {
                print(error.localizedDescription)
                showAlertDialog(error: error.localizedDescription)
            }
        }
    }
    
    private func showAlertDialog(error: String) {
        alert.message = error
        alert.addAction(UIAlertAction(title: LocalizedStrings.alertActionTitle, style: .default, handler: {
            action in
            switch action.style {
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            @unknown default:
                print("Unknown")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped on index: \(indexPath.row)")
        articlesTableView.deselectRow(at: indexPath, animated: true)
        
        let detailsViewController = DetailsViewController()
        let article = articles[indexPath.row]
        
        detailsViewController.titleArticle = article.title
        detailsViewController.summaryArticle = article.summary
        detailsViewController.imageArticle = article.media
        detailsViewController.linkArticle = article.link
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
            let article = articles[indexPath.row]
            articleCell.UpdateCellView(article: article)
            return articleCell
        } else {
            return ArticleCell()
        }
    }
}
