//
//  HomeRouter.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation

protocol HomeRouter {
    func navigateToDetailsController(article: Article)
    func navigateToSearchController()
}
