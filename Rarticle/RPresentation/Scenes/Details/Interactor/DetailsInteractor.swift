//
//  DetailsInteractor.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation

protocol IDetailsInteractor {
    func handleInitialize(article: Article)
}

class DetailsInteractor: IDetailsInteractor {
    
    private var detailsPresenter: IDetailsPresenter
    private var router: DetailsRouter
    
    init(detailsPresenter: DetailsPresenter, router: DetailsRouter) {
        self.detailsPresenter = detailsPresenter
        self.router = router
    }
}

extension DetailsInteractor {
    func handleInitialize(article: Article) {
        detailsPresenter.presentArticle(article: article)
    }
}
