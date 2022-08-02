//
//  ArticleViewModelMapper.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 29/07/2022.
//

import Foundation
import Resolver

class ArticleViewModelMapper {
    func map(article: Article) -> ArticleCell.ViewModel {
        return ArticleCell.ViewModel(
            id: article.id,
            title: article.title ?? LocalizedStrings.noTitle,
            description: article.description ?? LocalizedStrings.noDescription,
            image: article.image,
            urlArticle: article.url,
            author: article.author,
            publishedAt: article.publishedDate
        )
    }
}
