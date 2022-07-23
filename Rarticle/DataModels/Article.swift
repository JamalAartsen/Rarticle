//
//  Article.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 04/07/2022.
//

import Foundation

// Names need to be the same as in the API
struct Article: Codable {
    let description: String
    let title: String
    let url: String
    let urlToImage: String?
    let author: String?
    let publishedAt: String
    
    init(from decoder: Decoder) throws {
        do {
            // TODO: Kan dit? Dit bespreken met Kevin
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.description = try container.decodeIfPresent(String.self, forKey: CodingKeys.description) ?? "No description"
            self.title = try container.decodeIfPresent(String.self, forKey: CodingKeys.title) ?? "No title"
            self.url = try container.decodeIfPresent(String.self, forKey: CodingKeys.url) ?? "No url"
            self.urlToImage = try container.decodeIfPresent(String.self, forKey: CodingKeys.urlToImage)
            self.author = try container.decodeIfPresent(String.self, forKey: CodingKeys.author) ?? LocalizedStrings.noAuthor
            self.publishedAt = try container.decodeIfPresent(String.self, forKey: CodingKeys.publishedAt) ?? "No date"
        }
    }
    
    // TODO: Kan dit? Vragen aan Kevin of dit kan
    func stringToUrlConverter() -> URL {
        return URL(string: urlToImage ?? Constants.placeHolderImage)!
    }
}
