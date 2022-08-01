//
//  UITableView+Extensions.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 19/07/2022.
//

import Foundation
import UIKit

extension UITableView {
    func showSpinner(showSpinner: Bool) {
        let spinner = UIActivityIndicatorView(style: .large)
        if showSpinner {
            spinner.startAnimating()
            self.backgroundView = spinner
        } else {
            self.backgroundView = nil
        }
    }
    
    func showMessage(show: Bool, messageResult: String) {
        let message = UILabel()
        message.text = messageResult
        message.textAlignment = NSTextAlignment.center
      
        if show {
            self.backgroundView = message
        }
    }
    
    func lastItem() -> IndexPath {
        let section = max(numberOfSections - 1, 0)
        let row = max(numberOfRows(inSection: section) - 1, 0)
        
        return IndexPath(row: row, section: section)
    }
}
