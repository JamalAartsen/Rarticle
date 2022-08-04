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
    @Injected private var dateFormatterService: DateMapper
    
    // TODO: Date strings omzetten naar Date.
    func map(entity: ArticleEntity) -> Article? {
        guard let url = urlMapper.mapToUrl(stringUrl: entity.url) else { return nil }
        return Article(
            id: UUID().uuidString,
            description: entity.description,
            title: entity.title,
            url: url,
            image: urlMapper.mapToUrl(stringUrl:  entity.urlToImage),
            author: entity.author,
            publishedDate: dateFormatterService.map(date: entity.publishedAt)
        )
    }
}
