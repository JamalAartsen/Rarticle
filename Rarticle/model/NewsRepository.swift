//
//  NewsRepository.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 12/07/2022.
//

import Foundation
import Resolver

class NewsRepository {
    @Injected var iNewsAPI: INewsAPI
    
    func getAllNewsArticles() async throws -> Response {
        return try await iNewsAPI.getAllNewsArticles()
    }
    
    func getNewsArticlesFromTopic(topic: String) async throws -> Response {
        return try await iNewsAPI.getNewsArticlesFromTopic(topic: topic)
    }
}
