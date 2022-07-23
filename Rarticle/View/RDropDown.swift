//
//  RDropDown.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 23/07/2022.
//

import Foundation
import DropDown

typealias RDropDown = DropDown

extension RDropDown {
    static func makeDropDown(cornerRadius: Int? = 0) ->RDropDown {
        let rDropDown = DropDown()
        rDropDown.cornerRadius = CGFloat(cornerRadius!)
        
        return rDropDown
    }
}

// TODO: Kan dit? datasource en anchorView hier in?
//extension RDropDown {
//    static func makeDropDown(cornerRadius: Int? = 0, items: [String], view: AnchorView) ->RDropDown {
//        let rDropDown = DropDown()
//        rDropDown.cornerRadius = CGFloat(cornerRadius!)
//        rDropDown.dataSource = items
//        rDropDown.anchorView = view
//
//        return rDropDown
//    }
//}
