//
//  INewsAPI.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 12/07/2022.
//

import Foundation

protocol INewsAPI {
    func getAllNewsArticles(topic: String?) async throws -> Response
}

// TODO: 
enum NewsApiError: Error {
    case general(message: String)
}
