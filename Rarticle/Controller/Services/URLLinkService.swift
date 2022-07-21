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
        // TODO: Kan dit? Add guard and async als URL niet in model gedaan wordt +  wordt toch al async gedaan?
        application.open(URL(string: link)!)
    }
}
//
