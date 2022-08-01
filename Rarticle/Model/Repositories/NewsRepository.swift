//
//  NewsRepository.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 12/07/2022.
//

import Foundation
import Resolver

// Use Case
class NewsRepository {
    @Injected private var iNewsAPI: INewsAPI
    
    func getAllNewsArticles(topic: String?, sortByIndex: Int, page: Int) async throws -> [ArticleEntity] {
        return try await iNewsAPI.FetchData(topic: topic, sortByIndex: sortByIndex, page: page)
    }
}
