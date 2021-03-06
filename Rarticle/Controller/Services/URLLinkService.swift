//
//  URLLinkServices.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 20/07/2022.
//

import Foundation
import Resolver

class URLLinkService {
    @Injected private var application: UIApplication
    
    func openUrl(link: String) {
        application.open(URL(string: link)!)
    }
}
