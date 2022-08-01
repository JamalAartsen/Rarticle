//
//  AppDelegate+Injection.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 11/07/2022.
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerAPIServices()
        registerControllerServices()
        registerHomeViewControllerServices()
    }
}
