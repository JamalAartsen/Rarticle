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
    
    private var sortingType: SortingType {
        didSet {
            currentSortingType = sortingType
        }
    }
    private var currentSortingType: SortingType = SortingType.publishedAt
    private let noResultsText = LocalizedStrings.noResults
    
    init(searchPresenter: SearchPresenter, router: SearchRouter) {
        self.searchPresenter = searchPresenter
        self.isLoadingNextPage = false
        self.router = router
        self.sortingType = SortingType.publishedAt
    }
    
}

extension SearchInteractor {
    private func getArticles(topic: String?, sortingType: SortingType?, isFiltered: Bool) {
        if isFiltered {
            currentPage = 1
        }
        //sortByIndex = sortIndex ?? currentSortIndex
        self.topic = topic
        
        self.sortingType = sortingType ?? currentSortingType

        Task {
            do {
                let articlesFromWorker = try await getArticlesWorker.getArticles(topic: topic, sortingType: self.sortingType, page: currentPage)

                articles = articlesFromWorker
                searchPresenter.presentArticles(articles: articles, noResults: noResultsText)
            }
            catch let error {
                searchPresenter.presentErrorMessage(message: error.localizedDescription)
            }
        }
    }
    
    func handleInitialize(topic: String?) {
        getArticles(topic: topic, sortingType: nil, isFiltered: false)
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
        getArticles(topic: topic, sortingType: sortingType, isFiltered: false)
    }
    
    func handleDidTapRefresh() {
        getArticles(topic: topic, sortingType: sortingType, isFiltered: false)
    }
    
    func handleDidTapDropdownItem(sortIndex: Int) {
        guard !(articles.isEmpty) else { return }
        sortingType = sortingTypes[sortIndex]
        getArticles(topic: topic, sortingType: sortingType, isFiltered: true)
    }
    
    func handleLocalization() {
        searchPresenter.presentLocalization(sortingTypes: SortingType.allCases, retryButtonTitle: LocalizedStrings.retry, searchPlaceHolderText: LocalizedStrings.placeholderSearch)
    }
}
