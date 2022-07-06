//
//  Response.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 04/07/2022.
//

import Foundation

struct Response: Codable {
    let status: String
    let articles: [Article]
}
