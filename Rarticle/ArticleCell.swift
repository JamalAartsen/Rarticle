//
//  ArticleCell.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 05/07/2022.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var titleArticle: UILabel!
    @IBOutlet weak var summaryArticle: UILabel!
    @IBOutlet weak var imageArticle: UIImageView!
    
    func UpdateCellView(article: Article) {
        titleArticle.text = article.title
        summaryArticle.text = article.summary
        imageArticle.loadFrom(urlAdress: article.media)
    }
}
