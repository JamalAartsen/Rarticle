//
//  INewsAPI.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 12/07/2022.
//

import Foundation

protocol INewsAPI {
    // TODO: Algemeen get
    func FetchData(topic: String?, sortBy: String, page: Int) async throws -> Response
}

// TODO: 
enum NewsApiError: Error {
    case general(message: String)
}
