//
//  RFooterSpinner.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 26/07/2022.
//

import Foundation
import UIKit
import EasyPeasy

typealias RFooterSpinner = UIView

extension RFooterSpinner {
    static func makeFooterSpinner(view: UIView) -> RFooterSpinner {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}
