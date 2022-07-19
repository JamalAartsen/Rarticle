//
//  INewsAPI.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 12/07/2022.
//

import Foundation

protocol INewsAPI {
    func getAllNewsArticles() async throws -> Response
    func getNewsArticlesFromTopic(topic: String) async throws -> Response
}

enum NewsApiError: Error {
    case general(message: String)
}
