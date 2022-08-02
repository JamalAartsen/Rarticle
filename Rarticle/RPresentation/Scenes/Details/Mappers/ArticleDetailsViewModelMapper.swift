//
//  ArticleDetailsViewModelMapper.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation

class ArticleDetailsViewModelMapper {
    func map(article: Article) -> ArticleDetailsViewModel.ViewModel {
        return ArticleDetailsViewModel.ViewModel(
            title: article.title ?? LocalizedStrings.noTitle,
            description: article.description ?? LocalizedStrings.noDescription,
            image: article.image,
            urlArticle: article.url,
            author: article.author,
            publishedAt: article.publishedDate
        )
    }
}
