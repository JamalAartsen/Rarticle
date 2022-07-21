//
//  RAlertDialog.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 21/07/2022.
//

import Foundation
import UIKit

typealias RAlertDialog = UIAlertController

extension RAlertDialog {
    static func makeAlertDialog(title: String) -> RAlertDialog {
        let rAlertDialog = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        return rAlertDialog
    }
}
