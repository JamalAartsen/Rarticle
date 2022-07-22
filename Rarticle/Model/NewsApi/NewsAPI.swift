//
//  NewsAPI.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 18/07/2022.
//
import Foundation

class NewsApi: INewsAPI {
    private var session = URLSession.shared
    private let baseUrl = "newsapi.org"
    private let scheme = "https"
    private let apiKey = "5d18b3403d1e40b6a3c89cc4e368abed"
    private let baseTopic = "lord of the rings"
    private let totalArticles = 10
    
    // TODO: Vragen of ik het filteren op de juiste manier gedaan hebt.
    func getAllNewsArticles(topic: String?, sortBy: String) async throws -> Response {
        let queryItems = [
            URLQueryItem(name: "q", value: topic ?? baseTopic),
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "pageSize", value: "\(totalArticles)"),
            URLQueryItem(name: "sortBy", value: sortBy)
        ]
        let (data, _) = try await session.data(from: URL(string: .createComplicatedUrl(scheme: scheme, host: baseUrl, path: NewsAPIEndpoints.everythingEndpoint, queryItems: queryItems))!)
        let articles = try JSONDecoder().decode(Response.self, from: data)
        
        print("\(sortBy)")
        
        return articles
    }
}

struct NewsAPIEndpoints {
    static let everythingEndpoint = "/v2/everything"
}
