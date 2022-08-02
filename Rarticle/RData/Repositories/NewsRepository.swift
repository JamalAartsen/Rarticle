//
//  NewsRepository.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 12/07/2022.
//

import Foundation
import Resolver

class NewsRepository: GetArticlesWorker {
    @Injected private var iNewsAPI: INewsAPI
    @Injected private var articleMapper: ArticleMapper
    
    func getArticles(topic: String?, sortByIndex: Int, page: Int) async throws -> [Article] {
        return try await iNewsAPI.FetchData(topic: topic, sortByIndex: sortByIndex, page: page)
    }
}
