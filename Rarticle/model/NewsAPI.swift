//
//  NewsAPI.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 18/07/2022.
//

import Foundation

class NewsApi: INewsAPI {
    private var session = URLSession.shared
    private let baseUrl = "https://newsapi.org/v2/"
    private let apiKey = "5d18b3403d1e40b6a3c89cc4e368abed"
    // TODO: Needs to be dynamic
    private let aboutParameter = "bitcoin"
    
    func getAllNewsArticles() async throws -> Response {
        let (data, _) = try await session.data(from: URL(string: "\(baseUrl + NewsAPIEndpoints.everythingEndpoint)apikey=\(apiKey)&q=\(aboutParameter)")!)
        let articles = try JSONDecoder().decode(Response.self, from: data)
        
        return articles
    }
}

struct NewsAPIEndpoints {
    static let everythingEndpoint = "everything?"
}
