//
//  ControllerServices+Injection.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 20/07/2022.
//

import Resolver

extension Resolver {
    public static func registerControllerServices() {
        register { DateMapper() }
        register { UIApplication.shared }
    }
}
