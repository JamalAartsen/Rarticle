//
//  URLMapper.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 01/08/2022.
//

import Foundation

class URLMapper {
    // TODO: Fatal error: Unexpectedly found nil while unwrapping an Optional value -> URL?
    func mapToUrl(stringUrl: String?) -> URL? {
        guard let stringUrl = stringUrl else {
            return nil
        }

        return URL(string: stringUrl)
    }
    
    func mapToString(url: URL) -> String {
        return url.absoluteString
    }
}
