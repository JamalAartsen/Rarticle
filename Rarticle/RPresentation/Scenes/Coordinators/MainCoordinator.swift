//
//  MainCoordinator.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation
import UIKit
import SafariServices

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
        navigationController?.pushViewController(SearchViewController(router: self), animated: true)
    }
}

extension MainCoordinator: DetailsRouter {
    func navigateToArticle(link: URL) {
        let safariConfiguration = SFSafariViewController.Configuration()
        safariConfiguration.entersReaderIfAvailable = true
        let safariController = SFSafariViewController(url: link, configuration: safariConfiguration)
        
        navigationController?.present(safariController, animated: true)
    }
    
    func shareArticle(link: URL) {
        let text = LocalizedStrings.shareArticleText
        let activity = UIActivityViewController(activityItems: [link, text], applicationActivities: nil)
        
        navigationController?.present(activity, animated: true)
    }
}

extension MainCoordinator: SearchRouter {
    func navigateToDetailsControllerFromSearch(article: Article) {
        navigationController?.pushViewController(DetailsViewController(article: article, router: self), animated: true)
    }
}
