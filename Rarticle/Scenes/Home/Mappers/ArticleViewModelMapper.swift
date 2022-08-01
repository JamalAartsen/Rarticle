//
//  ArticleViewModelMapper.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 29/07/2022.
//

import Foundation
import Resolver

class ArticleViewModelMapper {
    @Injected var urlMapper: URLMapper
    
    func map(article: Article) -> ArticleCell.ViewModel {
        return ArticleCell.ViewModel(title: article.title ?? LocalizedStrings.noTitle,
                                     description: article.description ?? LocalizedStrings.noDescription,
                                     image: urlMapper.mapToString(url: article.image!))
    }
}
