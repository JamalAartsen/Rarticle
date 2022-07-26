//
//  NewsAPI.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 18/07/2022.
//
import Foundation

// TODO: Meestal zou je dus ook geen api hebben waar alle functies bij elkaar zitten, maar meer losse services voor deze losse calls. Deze services (bijv NewsArticlesService) roepen de APIService aan met een bepaalde base url, path en parameters, en handelen dan zelf intern het mappen af
// TODO: Base api en use cases
class NewsApi: INewsAPI {
    private var session = URLSession.shared
    private let baseUrl = "newsapi.org"
    private let scheme = "https"
    private let apiKey = "953ff053c2124cf281dff9eaabe54313"
    private let baseTopic = "lord of the rings"
    private let totalArticles = 2
    
    // TODO: Get method
    func FetchData(topic: String?, sortBy: String, page: Int) async throws -> Response {
        let queryItems = [
            URLQueryItem(name: "q", value: topic ?? baseTopic),
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "pageSize", value: "\(totalArticles)"),
            URLQueryItem(name: "sortBy", value: sortBy),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let (data, _) = try await session.data(from: URL(string: .createComplicatedUrl(scheme: scheme, host: baseUrl, path: NewsAPIEndpoints.everythingEndpoint, queryItems: queryItems))!)
        let articles = try JSONDecoder().decode(Response.self, from: data)
        
        return articles
    }
}

struct NewsAPIEndpoints {
    static let everythingEndpoint = "/v2/everything"
}
