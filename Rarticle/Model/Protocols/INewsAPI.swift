//
//  INewsAPI.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 12/07/2022.
//

import Foundation

protocol INewsAPI {
    func FetchData(topic: String?, sortBy: Int, page: Int) async throws -> [Article]
}

// TODO: 
enum NewsApiError: Error {
    case general(message: String)
}
