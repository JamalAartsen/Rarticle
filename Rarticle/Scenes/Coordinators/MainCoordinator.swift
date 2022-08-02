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
        print("Navigate to details")
    }
    
    func navigateToSearchController() {
        let vc = SearchViewController()
    
        navigationController?.pushViewController(vc, animated: true)
        print("Navigate to SearchViewController")
    }
}
