//
//  RTableView.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 22/07/2022.
//

import Foundation
import UIKit

typealias RTableView = UITableView

extension RTableView {
    static func makeTableView(cornerRadius: Int? = 0) -> RTableView {
        let tableView = UITableView()
        tableView.layer.cornerRadius = CGFloat(cornerRadius!)
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ArticleCell.self, forCellReuseIdentifier: Constants.articleCellIndentifier)
        return tableView
    }
}
