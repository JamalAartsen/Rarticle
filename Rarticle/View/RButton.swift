//
//  RButton.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 21/07/2022.
//

import Foundation
import UIKit

typealias RButton = UIButton

extension RButton {
    static func makeButton(backgroundColor: UIColor, cornerRadius: Int, title: String) -> RButton {
        let rButton = UIButton()
        rButton.backgroundColor = backgroundColor
        rButton.layer.cornerRadius = CGFloat(cornerRadius)
        rButton.setTitle(title, for: .normal)
        
        return rButton
    }
}
