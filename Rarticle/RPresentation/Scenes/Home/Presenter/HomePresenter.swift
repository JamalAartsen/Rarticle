//
//  HomePresenter.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 28/07/2022.
//

import Foundation
import Resolver

protocol IHomePresenter {
    func presentArticles(articles: [Article], noResults: String)
    func presentErrorMessage(message: String)
    func presentPaginationSpinner(show: Bool)
    func presentLocalization(sortingTypes: [SortingType], retryButtonTitle: String, appTitle: String, loadingArticles: String)
}

class HomePresenter: IHomePresenter {
    
    private var homeViewController: IHomeViewController
    @Injected private var articleViewModelMapper: ArticleViewModelMapper
    
    init(homeViewController: IHomeViewController) {
        self.homeViewController = homeViewController
    }
}

extension HomePresenter {
    func presentArticles(articles: [Article], noResults: String) {
        homeViewController.display(articles: articles.map({ articleViewModelMapper.map(article: $0) }), noResults: noResults)
    }
    
    func presentErrorMessage(message: String) {
        homeViewController.displayError(message: message)
    }
    
    func presentPaginationSpinner(show: Bool) {
        if show {
            homeViewController.displayPaginationSpinner()
        }
    }
    
    func presentLocalization(sortingTypes: [SortingType], retryButtonTitle: String, appTitle: String, loadingArticles: String) {
        let sorting = sortingTypes.map({ sortingType -> String in
            switch sortingType {
            case .publishedAt:
                return LocalizedStrings.sortByNewest
            case .popularity:
                return LocalizedStrings.sortByPopularity
            case .relevancy:
                return LocalizedStrings.sortByRelevancy
            }
        })
        
        homeViewController.displayLocalization(sortingTypes: sorting, retryButtonTitle: retryButtonTitle, appTitle: appTitle, loadingArticles: loadingArticles)
    }
}
