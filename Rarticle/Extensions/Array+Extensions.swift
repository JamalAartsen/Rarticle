//
//  Array+Extensions.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 14/07/2022.
//

import Foundation
import SwiftUI

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
    mutating func isPagination(isPagination: Bool, articles: [Article]) {
        if isPagination {
            self.append(contentsOf: articles)
        } else {
            self = articles
        }
    }
}
