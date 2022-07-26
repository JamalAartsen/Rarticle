//
//  String+Extensions.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 19/07/2022.
//

import Foundation

extension String {
    static func createComplicatedUrl(scheme: String, host: String, path: String, queryItems: [URLQueryItem]? = nil) -> Self {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        return components.url!.absoluteString
    }
}
