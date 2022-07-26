//
//  APIServices+Injection.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 11/07/2022.
//

import Resolver

extension Resolver {
    public static func registerAPIServices() {
        register { NewsRepository() }
        register { NewsApi() as INewsAPI }
        register { SortingService() }
    }
}
