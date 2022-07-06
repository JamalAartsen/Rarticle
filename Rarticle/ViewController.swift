//
//  ViewController.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 04/07/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var articles: [Article] = []
    
    let newsAPI = NewsCatcherApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Rarticle Articles"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print("Hallo")
        tableViewSpinner()
        getAllNewsArticles()
    }
    
    private func tableViewSpinner() {
        let spinner = UIActivityIndicatorView(style: .large)
        
        spinner.startAnimating()
        tableView.backgroundView = spinner
    }
    
    private func getAllNewsArticles() {
        Task {
            do {
                articles = try await newsAPI.getAllNewsArticles().articles
            
                self.tableView.reloadData()
                print(articles)
                print("Data is done")
            }
            catch let error {
                // Check this without internet!
                print("Something went wrong")
                print(error)
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("You tapped on index: \(indexPath)")
    }
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let articleCell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? ArticleCell {
            let article = articles[indexPath.row]
            articleCell.UpdateCellView(article: article)
            return articleCell
        } else {
            return ArticleCell()
        }
    }
}

extension UIImageView {
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
