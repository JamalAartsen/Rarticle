//
//  DetailsPresenter.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation
import Resolver

protocol IDetailsPresenter {
    func presentArticle(article: Article)
    func presentLocalization(articleButtonTitle: String, navigationItemTitle: String)
}

class DetailsPresenter: IDetailsPresenter {
    
    private var detailsViewController: IDetailsController
    @Injected private var articleDetailsViewModelMapper: ArticleDetailsViewModelMapper
    
    init(detailsViewController: IDetailsController) {
        self.detailsViewController = detailsViewController
    }
}

extension DetailsPresenter {
    func presentArticle(article: Article) {
        detailsViewController.display(article: articleDetailsViewModelMapper.map(article: article))
    }
    
    func presentLocalization(articleButtonTitle: String, navigationItemTitle: String) {
        detailsViewController.displayLocalization(
            articleButtonTitle: articleButtonTitle,
            navigationItemTitle: navigationItemTitle
        )
    }
}
