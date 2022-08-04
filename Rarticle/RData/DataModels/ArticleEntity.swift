//
//  Article.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 04/07/2022.
//

import Foundation

// Names need to be the same as in the API
struct ArticleEntity: Codable {
    let description: String?
    let title: String?
    let url: String
    let urlToImage: String?
    let author: String?
    let publishedAt: String
}
