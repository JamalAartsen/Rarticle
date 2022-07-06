//
//  NewsCatcherApi.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 04/07/2022.
//

import Foundation

class NewsCatcherApi {
    var session = URLSession.shared
    var request = URLRequest(url: URL(string: "https://newscatcher.p.rapidapi.com/v1/search_free?q=Elon%20Musk&lang=en&media=True")!)
    let headers = [
        "X-RapidAPI-Key": "17b7f54c55msh6d42a8a808346b1p195aa6jsn5305aa5948ed",
        "X-RapidAPI-Host": "newscatcher.p.rapidapi.com"
    ]
    
    func getAllNewsArticles() async throws -> Response {
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await session.data(for: request)
        
        guard(response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
        
        let articles = try JSONDecoder().decode(Response.self, from: data)
        print(articles.status)
       
        return articles
    }
}
