//
//  SortingServices.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 22/07/2022.
//

import Foundation

class SortingService {
    func sortBy(sortingType: SortingType) -> SortBy {
        switch sortingType {
        case .publishedAt:
            return SortBy.publishedAt
        case .popularity:
            return SortBy.popularity
        case .relevancy:
            return SortBy.relevancy
        }
    }
}
