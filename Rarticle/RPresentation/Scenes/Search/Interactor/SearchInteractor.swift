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
    private var sortByIndex: Int {
        didSet {
            currentSortIndex = sortByIndex
        }
    }
    private var isPaginating = false
    private var currentPage: Int = 1
    private var currentSortIndex: Int = 0
    private var router: SearchRouter
    
    init(searchPresenter: SearchPresenter, router: SearchRouter) {
        self.searchPresenter = searchPresenter
        self.isLoadingNextPage = false
        self.router = router
        sortByIndex = 0
    }
    
}

extension SearchInteractor {
    private func getArticles(topic: String?, sortIndex: Int?, isFiltered: Bool) {
        if isFiltered {
            currentPage = 1
        }
        sortByIndex = sortIndex ?? currentSortIndex
        self.topic = topic
        
        Task {
            do {
                let articlesFromWorker = try await getArticlesWorker.getArticles(topic: topic, sortByIndex: sortByIndex, page: currentPage)
                
                articles = articlesFromWorker
                searchPresenter.presentArticles(articles: articles)
            }
            catch let error {
                searchPresenter.presentErrorMessage(message: error.localizedDescription)
            }
        }
    }
    
    func handleInitialize(topic: String?) {
        getArticles(topic: topic, sortIndex: nil, isFiltered: false)
    }
    
    func handleDidScrollToLastCell() {
        guard isLoadingNextPage == false else { return }
        isLoadingNextPage = true
        currentPage += 1
        Task {
            do {
                let nextArticles = try await getArticlesWorker.getArticles(topic: topic, sortByIndex: self.sortByIndex, page: currentPage)
                articles.append(contentsOf: nextArticles)
                
                searchPresenter.presentArticles(articles: articles)
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
        getArticles(topic: topic, sortIndex: sortByIndex, isFiltered: false)
    }
    
    func handleDidTapRefresh() {
        getArticles(topic: topic, sortIndex: sortByIndex, isFiltered: false)
    }
    
    func handleDidTapDropdownItem(sortIndex: Int) {
        guard !(articles.isEmpty) else { return }
        // TODO: Index mag hier niet bewaard worden. soort van zelfde check als handleTapArticle
        getArticles(topic: topic, sortIndex: sortIndex, isFiltered: true)
    }
}
