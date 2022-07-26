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
    private let totalArticles = 2
    @Injected private var sortingService: SortingService
    
    func FetchData(topic: String?, sortByIndex: Int, page: Int) async throws -> [Article] {
        let queryItems = [
            URLQueryItem(name: "q", value: topic ?? baseTopic),
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "pageSize", value: "\(totalArticles)"),
            URLQueryItem(name: "sortBy", value: sortingService.sortBy(index: sortByIndex).rawValue),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let (data, _) = try await session.data(from: URL(string: .createComplicatedUrl(scheme: scheme, host: baseUrl, path: NewsAPIEndpoints.everythingEndpoint, queryItems: queryItems))!)
        let articles = try JSONDecoder().decode(Response.self, from: data)
        
        return articles.articles
    }
}

struct NewsAPIEndpoints {
    static let everythingEndpoint = "/v2/everything"
}
