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
    private lazy var descriptionLabel: UILabel = makeDescriptionLabel()
    private lazy var articleImage: UIImageView = makeArticleImage()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCellView(viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        articleImage.loadFrom(urlAdress: viewModel.image, placeholder: Constants.placeHolderImage)
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        descriptionLabel.text = ""
        articleImage.image = UIImage(named: Constants.placeHolderImage)
    }
    
    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(articleImage)
        
        titleLabel.easy.layout([
            Top(10),
            Left(10),
            Right(10).to(articleImage)
        ])
        
        descriptionLabel.easy.layout([
            Top(5).to(titleLabel),
            Left(10),
            Right(10).to(articleImage)
        ])
        
        articleImage.easy.layout([
            Width(100),
            Height(50),
            Right(10),
            Top(10).with(.high),
            Bottom(10).with(.high)
        ])
    }
}

private extension ArticleCell {
    func makeTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.textColor = Colors.blackWhiteTextColor
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        return titleLabel
    }
    
    func makeDescriptionLabel() -> UILabel {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = Colors.blackWhiteTextColor
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        return descriptionLabel
    }
    
    func makeArticleImage() -> UIImageView {
        let articleImage = UIImageView()
        articleImage.image = UIImage(named: Constants.placeHolderImage)
        return articleImage
    }
}

extension ArticleCell {
    struct ViewModel {
        let id: String
        let title: String
        let description: String
        let image: URL?
    }
}
