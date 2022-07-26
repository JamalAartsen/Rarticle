//
//  SortingServices.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 22/07/2022.
//

import Foundation

class SortingService {
    // TODO: Dit pas doen in de model laag !!!
    func sortBy(index: Int? = 0) -> String {
        switch index {
        case 0:
            return SortBy.publishedAt.rawValue
        case 1:
            return SortBy.popularity.rawValue
        case 2:
            return SortBy.relevancy.rawValue
        default:
            return SortBy.publishedAt.rawValue
        }
    }
    
    enum SortBy: String {
        case publishedAt
        case popularity
        case relevancy
    }
}
