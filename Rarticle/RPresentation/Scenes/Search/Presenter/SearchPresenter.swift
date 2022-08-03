//
//  SearchPresenter.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation
import Resolver

protocol ISearchPresenter {
    func presentArticles(articles: [Article])
    func presentErrorMessage(message: String)
    func presentPaginationSpinner(show: Bool)
}

class SearchPresenter: ISearchPresenter {
    
    private var searchViewController: ISearchViewController
    @Injected private var articleViewModelMapper: ArticleViewModelMapper
    
    init (searchViewController: ISearchViewController) {
        self.searchViewController = searchViewController
    }
}

extension SearchPresenter {
    func presentArticles(articles: [Article]) {
        searchViewController.display(articles: articles.map({
            articleViewModelMapper.map(article: $0)
        }))
    }
    
    func presentErrorMessage(message: String) {
        searchViewController.displayError(message: message)
    }
    
    func presentPaginationSpinner(show: Bool) {
        if show {
            searchViewController.displayPaginationSpinner()
        }
    }
}
