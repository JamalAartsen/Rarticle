//
//  ArticleCell.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 05/07/2022.
//

import UIKit
import EasyPeasy

class ArticleCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = makeTitleLabel()
    private lazy var summaryLabel: UILabel = makeSummaryLabel()
    private lazy var articleImage: UIImageView = makeArticleImage()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCellView(article: Article) {
        titleLabel.text = article.title
        summaryLabel.text = article.summary
        articleImage.loadFrom(urlAdress: article.media)
    }
    
    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(summaryLabel)
        contentView.addSubview(articleImage)
        
        titleLabel.easy.layout([
            Top(10),
            Left(10),
            Right(10).to(articleImage)
        ])
        
        summaryLabel.easy.layout([
            Top(5).to(titleLabel),
            Left(10),
            Right(10).to(articleImage)
        ])
        
        articleImage.easy.layout([
            Width(100),
            Right(10),
            Top(10),
            Bottom(10)
        ])
    }
}

private extension ArticleCell {
    func makeTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        return titleLabel
    }
    
    func makeSummaryLabel() -> UILabel {
        let summaryLabel = UILabel()
        summaryLabel.textColor = .black
        summaryLabel.font = .systemFont(ofSize: 12, weight: .regular)
        return summaryLabel
    }
    
    func makeArticleImage() -> UIImageView {
        let articleImage = UIImageView()
        articleImage.image = UIImage(named: "placeholder")
        return articleImage
    }
}
