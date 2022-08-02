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
