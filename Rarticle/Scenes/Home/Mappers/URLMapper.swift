//
//  URLMapper.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 01/08/2022.
//

import Foundation

class URLMapper {
    func mapToUrl(stringUrl: String) -> URL {
        return URL(string: stringUrl) ?? URL(string: Constants.placeHolderImage)!
    }
    
    func mapToString(url: URL) -> String {
        return url.absoluteString
    }
}
