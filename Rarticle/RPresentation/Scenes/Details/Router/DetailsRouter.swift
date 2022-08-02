//
//  DetailsRouter.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation

protocol DetailsRouter {
    func navigateToArticle(link: URL)
    func shareArticle(link: URL)
}
