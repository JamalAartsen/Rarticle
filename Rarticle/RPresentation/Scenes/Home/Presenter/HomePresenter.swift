//
//  HomePresenter.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 28/07/2022.
//

import Foundation
import Resolver

protocol IHomePresenter {
    func presentArticles(articles: [Article])
    func presentErrorMessage(message: String)
    func presentPaginationSpinner(show: Bool)
}

class HomePresenter: IHomePresenter {
    
    private var homeViewController: IHomeViewController
    @Injected private var articleViewModelMapper: ArticleViewModelMapper
    
    init(homeViewController: IHomeViewController) {
        self.homeViewController = homeViewController
    }
}

extension HomePresenter {
    func presentArticles(articles: [Article]) {
        homeViewController.display(articles: articles.map({ articleViewModelMapper.map(article: $0) }))
    }
    
    func presentErrorMessage(message: String) {
        homeViewController.displayError(message: message)
    }
    
    func presentPaginationSpinner(show: Bool) {
        if show {
            homeViewController.displayPaginationSpinner()
        }
    }
}
