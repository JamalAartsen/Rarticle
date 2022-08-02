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
    func handleDidTapArticle(article: Article)
    func handleDidTapReload()
    func handleDidTapRefresh()
    func handleDidTapDropdownItem(sortIndex: Int)
}

class HomeInteractor: IHomeInteractor {
    
    private var homePresenter: IHomePresenter
    @Injected private var newsRepository: NewsRepository
    @Injected private var articleMapper: ArticleMapper
    
    private var articles: [ArticleEntity] = []
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
    
    
    init(homePresenter: IHomePresenter, router: HomeRouter) {
        self.homePresenter = homePresenter
        self.isLoadingNextPage = false
        self.router = router
        sortByIndex = 0
    }
}

extension HomeInteractor {
    private func getLoad(topic: String?, sortIndex: Int?, isFiltered: Bool) {
        if isFiltered {
            currentPage = 1
        }
        sortByIndex = sortIndex ?? currentSortIndex
        
        Task {
            do {
                let articlesAPI = try await newsRepository.getAllNewsArticles(topic: topic, sortByIndex: sortByIndex, page: currentPage)
                
                articles = articlesAPI
                homePresenter.presentArticles(articles: articles.compactMap({ articleMapper.map(entity: $0) }))
            }
            catch let error {
                homePresenter.presentErrorMessage(message: error.localizedDescription)
            }
        }
    }
    
    func handleInitialize() {
        getLoad(topic: nil, sortIndex: nil, isFiltered: false)
    }
    
    func handleDidTapReload() {
        getLoad(topic: nil, sortIndex: nil, isFiltered: false)
    }
    
    func handleDidTapRefresh() {
        getLoad(topic: nil, sortIndex: nil, isFiltered: false)
    }
    
    func handleDidTapDropdownItem(sortIndex: Int) {
        getLoad(topic: nil, sortIndex: sortIndex, isFiltered: true)
    }
    
    func handleDidScrollToLastCell() {
        guard isLoadingNextPage == false else { return }
        isLoadingNextPage = true
        currentPage += 1
        Task {
            do {
                let nextArticles = try await newsRepository.getAllNewsArticles(topic: topic, sortByIndex: self.sortByIndex, page: currentPage)
                articles.append(contentsOf: nextArticles)
                
                homePresenter.presentArticles(articles: articles.compactMap({
                    articleMapper.map(entity: $0)
                }))
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
    
    func handleDidTapArticle(article: Article) {
        router.navigateToDetailsController(article: article)
    }
}
