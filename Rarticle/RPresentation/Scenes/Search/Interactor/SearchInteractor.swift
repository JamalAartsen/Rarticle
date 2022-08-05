    //
//  SearchInteractor.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation
import Resolver

protocol ISearchInteractor {
    func handleInitialize(topic: String?)
    func handleLocalization()
    func handleDidScrollToLastCell()
    func handleTapArticle(articleID: String)
    func handleDidTapReload()
    func handleDidTapRefresh()
    func handleDidTapDropdownItem(sortIndex: Int)
}

class SearchInteractor: ISearchInteractor {
    
    private var searchPresenter: ISearchPresenter
    @Injected private var articleMapper: ArticleMapper
    @Injected private var getArticlesWorker: GetArticlesWorker
    
    private var articles: [Article] = []
    private var isLoadingNextPage: Bool {
        didSet {
            searchPresenter.presentPaginationSpinner(show: isLoadingNextPage)
        }
    }
    private var topic: String? = nil
    private var isPaginating = false
    private var currentPage: Int = 1
    private var router: SearchRouter
    private var sortingTypes = SortingType.allCases
    private var sortingType: SortingType = SortingType.publishedAt
    private let noResultsText = LocalizedStrings.noResults
    
    init(searchPresenter: SearchPresenter, router: SearchRouter) {
        self.searchPresenter = searchPresenter
        self.isLoadingNextPage = false
        self.router = router
    }
}

extension SearchInteractor {
    private func isFiltered(isFiltered: Bool) {
        if isFiltered {
            currentPage = 1
        }
    }
    
    private func getArticles() {
        Task {
            do {
                let articlesFromWorker = try await getArticlesWorker.getArticles(topic: topic, sortingType: sortingType, page: currentPage)

                articles = articlesFromWorker
                searchPresenter.presentArticles(articles: articles, noResults: noResultsText)
            }
            catch let error {
                searchPresenter.presentErrorMessage(message: error.localizedDescription)
            }
        }
    }
    
    func handleInitialize(topic: String?) {
        self.topic = topic
        getArticles()
    }
    
    func handleDidScrollToLastCell() {
        guard isLoadingNextPage == false else { return }
        isLoadingNextPage = true
        currentPage += 1
        Task {
            do {
                let nextArticles = try await getArticlesWorker.getArticles(topic: topic, sortingType: sortingType, page: currentPage)
                articles.append(contentsOf: nextArticles)

                searchPresenter.presentArticles(articles: articles, noResults: noResultsText)
                isLoadingNextPage = false
            }
            catch let error {
                searchPresenter.presentErrorMessage(message: error.localizedDescription)
                isLoadingNextPage = false
            }
        }
    }
    
    func handleTapArticle(articleID: String) {
        guard let article = articles.first(where: { $0.id == articleID }) else { return }
        router.navigateToDetailsControllerFromSearch(article: article)
    }
    
    func handleDidTapReload() {
        getArticles()
    }
    
    func handleDidTapRefresh() {
        getArticles()
    }
    
    func handleDidTapDropdownItem(sortIndex: Int) {
        guard !(articles.isEmpty) else { return }
        sortingType = sortingTypes[sortIndex]
        isFiltered(isFiltered: true)
        getArticles()
    }
    
    func handleLocalization() {
        searchPresenter.presentLocalization(sortingTypes: SortingType.allCases, retryButtonTitle: LocalizedStrings.retry, searchPlaceHolderText: LocalizedStrings.placeholderSearch)
    }
}
