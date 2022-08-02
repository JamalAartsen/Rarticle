//
//  DetailsInteractor.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation

protocol IDetailsInteractor {
    func handleInitialize(article: Article)
    func handleDidTapLink()
    func handleDidTapShareButton()
}

class DetailsInteractor: IDetailsInteractor {
    
    private var detailsPresenter: IDetailsPresenter
    private var router: DetailsRouter
    private var article: Article?
    
    init(detailsPresenter: DetailsPresenter, router: DetailsRouter) {
        self.detailsPresenter = detailsPresenter
        self.router = router
    }
}

extension DetailsInteractor {
    func handleInitialize(article: Article) {
        self.article = article
        detailsPresenter.presentArticle(article: article)
    }
    
    func handleDidTapLink() {
        // TODO: ! moet weg
        router.navigateToArticle(link: article!.url)
    }
    
    func handleDidTapShareButton() {
        router.shareArticle(link: article!.url)
    }
}
