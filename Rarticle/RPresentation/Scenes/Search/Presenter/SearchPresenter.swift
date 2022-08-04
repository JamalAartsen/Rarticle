//
//  SearchPresenter.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation
import Resolver

protocol ISearchPresenter {
    func presentArticles(articles: [Article], noResults: String)
    func presentErrorMessage(message: String)
    func presentPaginationSpinner(show: Bool)
    func presentLocalization(sortingTypes: [SortingType], retryButtonTitle: String, searchPlaceHolderText: String)
}

class SearchPresenter: ISearchPresenter {
    
    private var searchViewController: ISearchViewController
    @Injected private var articleViewModelMapper: ArticleViewModelMapper
    
    init (searchViewController: ISearchViewController) {
        self.searchViewController = searchViewController
    }
}

extension SearchPresenter {
    func presentArticles(articles: [Article], noResults: String) {
        searchViewController.display(articles: articles.map({
            articleViewModelMapper.map(article: $0)
        }), noResults: noResults)
    }
    
    func presentErrorMessage(message: String) {
        searchViewController.displayError(message: message)
    }
    
    func presentPaginationSpinner(show: Bool) {
        if show {
            searchViewController.displayPaginationSpinner()
        }
    }
    
    func presentLocalization(sortingTypes: [SortingType], retryButtonTitle: String, searchPlaceHolderText: String) {
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
        
        searchViewController.displayLocalization(sortingTypes: sorting, retryButtonTitle: retryButtonTitle, searchPlaceHolderText: searchPlaceHolderText)
    }
}
