//
//  ArticleMapper.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 29/07/2022.
//

import Foundation

class ArticleMapper {
    // TODO: Url strings omzetten naar URL. Date strings omzetten naar Date.
    func map(entity: ArticleEntity) -> Article {
        return Article(
            description: entity.description,
            title: entity.title,
            url: entity.url,
            image: entity.urlToImage,
            author: entity.author,
            publishedDate: entity.publishedAt
        )
    }
}
