//
//  HomeViewcontroller+Injection.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 29/07/2022.
//

import Resolver

extension Resolver {
    public static func registerHomeViewControllerServices() {
        register { ArticleMapper() }
        register { ArticleViewModelMapper() }
    }
}
