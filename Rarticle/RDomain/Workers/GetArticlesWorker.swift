//
//  GetArticlesWorker.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation

public protocol GetArticlesWorker {
    func getArticles(topic: String?, sortByIndex: Int, page: Int) async throws -> [Article]
}
