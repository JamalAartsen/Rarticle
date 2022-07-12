//
//  INewsAPI.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 12/07/2022.
//

import Foundation

protocol INewsAPI {
    // Return type moet misschien veranderd worden
    func getAllNewsArticles() async throws -> Response
}
