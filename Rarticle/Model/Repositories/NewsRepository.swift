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
    
    // TODO: Return articles
    func getAllNewsArticles(topic: String?, sortBy: String, page: Int) async throws -> Response {
        return try await iNewsAPI.FetchData(topic: topic, sortBy: sortBy, page: page)
    }
}
