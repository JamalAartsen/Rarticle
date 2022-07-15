//
//  Array+Extensions.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 14/07/2022.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        if (index < 0 || index >= count) {
            return nil
        } else {
            return self[index]
        }
    }
}

extension Array where Element == Article {
    func sortingByTitle(index: Int) -> Self {
        switch index {
        case 0:
            // A-Z
            return sorted(by: { $0.title < $1.title })
        case 1:
            // Z-A
            return sorted(by: { $0.title > $1.title })
        default:
            // A-Z
            return sorted(by: { $0.title < $1.title })
        }
    }
    
    func sorting(by sortingType: SortingType) -> Self {
        switch sortingType {
        case .TITLE:
            print("title")
            return sorted(by: { $0.title < $1.title })
        case .DATE:
            print("date")
            return self
        case .POPULARITY:
            print("popularity")
            return self
        }
    }
    
    enum SortingType {
        case TITLE
        case DATE
        case POPULARITY
    }
}
