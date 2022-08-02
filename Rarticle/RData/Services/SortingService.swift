//
//  SortingServices.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 22/07/2022.
//

import Foundation

class SortingService {
    func sortBy(index: Int? = 0) -> SortBy {
        switch index {
        case 0:
            return SortBy.publishedAt
        case 1:
            return SortBy.popularity
        case 2:
            return SortBy.relevancy
        default:
            return SortBy.publishedAt
        }
    }
}
