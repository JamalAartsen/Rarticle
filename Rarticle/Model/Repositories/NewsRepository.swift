//
//  NewsRepository.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 12/07/2022.
//

import Foundation
import Resolver

class NewsRepository {
    @Injected private var iNewsAPI: INewsAPI
    
    func getAllNewsArticles(topic: String?, sortBy: String) async throws -> Response {
        return try await iNewsAPI.getAllNewsArticles(topic: topic, sortBy: sortBy)
    }
}
