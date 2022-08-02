//
//  MainCoordinator.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    
    func start() {
        let vc = HomeViewController(router: self)
        navigationController?.setViewControllers([vc], animated: false)
    }
}

extension MainCoordinator: HomeRouter {
    func navigateToDetailsController(article: Article) {
        navigationController?.pushViewController(DetailsViewController(article: article, router: self), animated: true)
    }
    
    func navigateToSearchController() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}

extension MainCoordinator: DetailsRouter {
    func navigateToArticle() {
        print("Navigate to Article webview")
    }
    
    func shareArticle() {
        print("Share article")
    }
}
