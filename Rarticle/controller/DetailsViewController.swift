//
//  DetailsViewController.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 11/07/2022.
//

import Foundation
import UIKit
import EasyPeasy

class DetailsViewController: UIViewController {
    
    var titleArticle: String = "No Title"
    var summaryArticle: String = "No Summary"
    var imageArticle: String = "No Image"
    var linkArticle: String = "No Link"
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        return titleLabel
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        navigationItem.title = "News Details"
        
        view.addSubview(titleLabel)
        
        titleLabel.text = titleArticle
        titleLabel.numberOfLines = 0
        
        setupLayout()
        
        print("Title: \(titleArticle)")
        print("Summary: \(summaryArticle)")
        print("Media: \(imageArticle)")
        print("Link: \(linkArticle)")
    }
    
    private func setupLayout() {
        titleLabel.easy.layout([
            Top(75),
            Left(10),
            Right(10)
        ])
    }
}
