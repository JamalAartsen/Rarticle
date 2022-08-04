//
//  NewsAPI.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 18/07/2022.
//
import Foundation
import Resolver

class NewsApi: INewsAPI {
    private var session = URLSession.shared
    private let baseUrl = "newsapi.org"
    private let scheme = "https"
    private let apiKey = "5058511a78c14df4919a209a0e282b5d"
    private let baseTopic = "lord of the rings"
    private let totalArticles = 20
    @Injected private var sortingService: SortingService
    @Injected private var articleMapper: ArticleMapper
    
    func FetchData(topic: String?, sortingType: SortingType, page: Int) async throws -> [Article] {
        let queryItems = [
            URLQueryItem(name: "q", value: topic ?? baseTopic),
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "pageSize", value: "\(totalArticles)"),
            URLQueryItem(name: "sortBy", value: sortingService.sortBy(sortingType: sortingType).rawValue),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let (data, _) = try await session.data(from: URL(string: .createComplicatedUrl(scheme: scheme, host: baseUrl, path: NewsAPIEndpoints.everythingEndpoint, queryItems: queryItems))!)
        let articles = try JSONDecoder().decode(Response.self, from: data)
        
        return articles.articles.compactMap({ articleMapper.map(entity: $0) })
    }
}

struct NewsAPIEndpoints {
    static let everythingEndpoint = "/v2/everything"
}