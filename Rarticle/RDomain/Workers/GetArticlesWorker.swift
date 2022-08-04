//
//  GetArticlesWorker.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation

public protocol GetArticlesWorker {
    func getArticles(topic: String?, sortingType: SortingType, page: Int) async throws -> [Article]
}
