//
//  ArticleViewModelMapper.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 29/07/2022.
//

import Foundation

class ArticleViewModelMapper {
    func map(article: Article) -> ArticleCell.ViewModel {
        return ArticleCell.ViewModel(title: article.title ?? LocalizedStrings.noTitle,
                                     description: article.description ?? LocalizedStrings.noDescription,
                                     image: article.image ?? Constants.placeHolderImage)
    }
}
