//
//  registerMapperServices.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 01/08/2022.
//

import Foundation
import Resolver

extension Resolver {
    public static func registerMapperServices() {
        register { ArticleMapper() }
        register { ArticleViewModelMapper() }
        register { URLMapper() }
    }
}
