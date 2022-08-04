//
//  HomeInteractor.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 28/07/2022.
//

import Foundation
import Resolver

protocol IHomeInteractor {
    func handleInitialize()
    func handleDidScrollToLastCell()
    func handleDidTapSearch()
    func handleDidTapArticle(articleID: String)
    func handleDidTapReload()
    func handleDidTapRefresh()
    func handleDidTapDropdownItem(sortIndex: Int)
}

class HomeInteractor: IHomeInteractor {
    
    private var homePresenter: IHomePresenter
    @Injected private var articleMapper: ArticleMapper
    @Injected private var getArticlesWorker: GetArticlesWorker
    
    private var articles: [Article] = []
    private var isLoadingNextPage: Bool {
        didSet {
            homePresenter.presentPaginationSpinner(show: isLoadingNextPage)
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
    private var router: HomeRouter
    private var sortingTypes = SortingType.allCases
    
    
    init(homePresenter: IHomePresenter, router: HomeRouter) {
        self.homePresenter = homePresenter
        self.isLoadingNextPage = false
        self.router = router
        sortByIndex = 0
    }
}

extension HomeInteractor {
    private func getArticles(topic: String?, sortIndex: Int?, isFiltered: Bool) {
        if isFiltered {
            currentPage = 1
        }
        sortByIndex = sortIndex ?? currentSortIndex
        
        Task {
            do {
                let articlesFromWorker = try await getArticlesWorker.getArticles(topic: topic, sortingType: sortingTypes[sortByIndex], page: currentPage)

                articles = articlesFromWorker
                homePresenter.presentArticles(articles: articles)
            }
            catch let error {
                homePresenter.presentErrorMessage(message: error.localizedDescription)
            }
        }
    }
    
    func handleInitialize() {
        getArticles(topic: nil, sortIndex: nil, isFiltered: false)
        homePresenter.presentInitialize(sortingTypes: SortingType.allCases)
    }
    
    func handleDidTapReload() {
        getArticles(topic: nil, sortIndex: sortByIndex, isFiltered: false)
    }
    
    func handleDidTapRefresh() {
        getArticles(topic: nil, sortIndex: sortByIndex, isFiltered: false)
    }
    
    func handleDidTapDropdownItem(sortIndex: Int) {
        getArticles(topic: nil, sortIndex: sortIndex, isFiltered: true)
    }
    
    func handleDidScrollToLastCell() {
        guard isLoadingNextPage == false else { return }
        isLoadingNextPage = true
        currentPage += 1
        Task {
            do {
                let nextArticles = try await getArticlesWorker.getArticles(topic: topic, sortingType: sortingTypes[sortByIndex], page: currentPage)
                articles.append(contentsOf: nextArticles)

                homePresenter.presentArticles(articles: articles)
                isLoadingNextPage = false
            }
            catch let error {
                homePresenter.presentErrorMessage(message: error.localizedDescription)
                isLoadingNextPage = false
            }
        }
    }
    
    func handleDidTapSearch() {
        router.navigateToSearchController()
    }
    
    func handleDidTapArticle(articleID: String) {
        guard let article = articles.first(where: { $0.id == articleID }) else { return }
        router.navigateToDetailsController(article: article)
    }
}
