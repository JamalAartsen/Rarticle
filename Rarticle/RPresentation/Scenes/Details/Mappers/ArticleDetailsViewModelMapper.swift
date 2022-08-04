//
//  ArticleDetailsViewModelMapper.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation
import Resolver

class ArticleDetailsViewModelMapper {
    func map(article: Article) -> ArticleDetailsViewModel.ViewModel {
        return ArticleDetailsViewModel.ViewModel(
            title: article.title ?? LocalizedStrings.noTitle,
            description: article.description ?? LocalizedStrings.noDescription,
            image: article.image,
            author: article.author ?? LocalizedStrings.noAuthor,
            publishedAt: article.publishedDate
        )
    }
}
