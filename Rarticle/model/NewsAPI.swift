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
    // TODO: Kan dit? Needs to be dynamic, first loading images is really slow + vragen over de plusjes
    // TODO: URL encoding gebruiken -> Inject services van maken of extension function
    private let aboutParameter = "lord+of+the+rings"
    private let totalArticles = 10
    
    // TODO: URL QUERY ITEM GEBRUIKEN + URLCOMPONENTS
    func getAllNewsArticles() async throws -> Response {
        let (data, _) = try await session.data(from: URL(string: "\(baseUrl + NewsAPIEndpoints.everythingEndpoint)apikey=\(apiKey)&q=\(aboutParameter)&pageSize=\(totalArticles)")!)
        let articles = try JSONDecoder().decode(Response.self, from: data)
        
        // TODO: enum newsapierror maken inherited van error: extension function
//        guard var components = URLComponents.init(string: baseUrl) else {
           // TODO: Nog goed kijken naar throwing error
//            throw NewsApiError.general(message: "Error!!!")
//        }
//        components?.path = NewsAPIEndpoints.everythingEndpoint
//        components?.queryItems
        
        print("\(baseUrl + NewsAPIEndpoints.everythingEndpoint)apikey=\(apiKey)&q=\(aboutParameter)&pageSize=\(totalArticles)")
        
        return articles
    }
    
    // TODO: Topics als lord of the rings kunnen niet. namen moeten aan elkaar + show something when there are no articles
    // TODO: Soms staat er dat er geen urlToImage is. is null
    // TODO: Wordt 1 methode hierboven
    func getNewsArticlesFromTopic(topic: String) async throws -> Response {
        let (data, _) = try await session.data(from: URL(string: "\(baseUrl + NewsAPIEndpoints.everythingEndpoint)apikey=\(apiKey)&q=\(topic)&pageSize=\(totalArticles)")!)
        let articles = try JSONDecoder().decode(Response.self, from: data)
        print(articles.status)
        print("Method is triggered")
        
        return articles
    }
}

struct NewsAPIEndpoints {
    static let everythingEndpoint = "everything?"
}
