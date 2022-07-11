//
//  ViewController.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 04/07/2022.
//

import UIKit
import EasyPeasy

class ViewController: UIViewController {
    
    let articlesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ArticleCell.self, forCellReuseIdentifier: Constants.ArticleCellIndentifier)
        return tableView
    }()
    
    var articles: [Article] = []
    
    let newsAPI = NewsCatcherApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sub views
        view.addSubview(articlesTableView)
        articlesTableView.allowsSelection = true
        
        title = "Rarticle Articles"
        
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
            Top(0),
            Bottom(0),
            Right(0),
            Left(0)
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
                articles = try await newsAPI.getAllNewsArticles().articles
                self.articlesTableView.reloadData()
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped on index: \(indexPath.row)")
        articlesTableView.deselectRow(at: indexPath, animated: true)
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
        if let articleCell = tableView.dequeueReusableCell(withIdentifier: Constants.ArticleCellIndentifier, for: indexPath) as? ArticleCell {
            let article = articles[indexPath.row]
            articleCell.UpdateCellView(article: article)
            articleCell.accessoryType = .disclosureIndicator
            return articleCell
        } else {
            return ArticleCell()
        }
    }
}

extension UIImageView {
    // Can use the library Nuke for this
    func loadFrom(urlAdress: String) {
        guard let url = URL(string: urlAdress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}
