//
//  ArticleMapper.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 29/07/2022.
//

import Foundation
import Resolver

class ArticleMapper {
    @Injected var urlMapper: URLMapper
    
    // TODO: Url strings omzetten naar URL. Date strings omzetten naar Date.
    func map(entity: ArticleEntity) -> Article {
        return Article(
            description: entity.description,
            title: entity.title,
            url: urlMapper.mapToUrl(stringUrl: entity.url),
            image:urlMapper.mapToUrl(stringUrl:  entity.urlToImage!),
            author: entity.author,
            publishedDate: entity.publishedAt
        )
    }
}
