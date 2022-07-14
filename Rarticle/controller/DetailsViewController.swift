//
//  DetailsViewController.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 11/07/2022.
//

import Foundation
import UIKit
import EasyPeasy

// TODO: Animatie hier toevoegen
class DetailsViewController: UIViewController {
    
    let titleArticle: String
    let summaryArticle: String
    let imageArticle: String
    let linkArticle: String
    
    private lazy var scrollView: UIScrollView = makeScrollView()
    private lazy var contentView: UIView = makeContentViewScrollView()
    private lazy var titleLabel: UILabel = makeTitleLabel()
    private lazy var summaryLabel: UILabel = makeSummaryLabel()
    private lazy var image: UIImageView = makeImage()
    private lazy var buttonLink: UIButton = makeButtonLink()
    
    internal init(titleArticle: String, summaryArticle: String, imageArticle: String, linkArticle: String) {
        self.titleArticle = titleArticle
        self.summaryArticle = summaryArticle
        self.imageArticle = imageArticle
        self.linkArticle = linkArticle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupLayout()
        buttonLink.addTarget(self, action: #selector(self.didTapOnLinkBtn), for: .touchUpInside)
        
        print("Title: \(titleArticle)")
        print("Summary: \(summaryArticle)")
        print("Media: \(imageArticle)")
        print("Link: \(linkArticle)")
    }
    
    @objc func didTapOnLinkBtn() {
        UIApplication.shared.open(URL(string: linkArticle)!)
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        navigationItem.title = LocalizedStrings.detailsViewControllerNavigationTitle
        
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
        
        titleLabel.text = titleArticle
        summaryLabel.text = summaryArticle + summaryArticle + summaryArticle + summaryArticle
        //image.loadFrom(urlAdress: imageArticle)
        image.image = UIImage(named: "placeholder")
        
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(buttonLink)
        contentView.addSubview(image)
        contentView.addSubview(summaryLabel)
        
        // topMargin = safearea = Top(0).to(view, .topMargin),
        scrollView.easy.layout([
            Top(0),
            Bottom(0),
            Left(0),
            Right(0)
        ])
        
        contentView.easy.layout([
            Edges(),
            Width().like(scrollView),
            CenterX()
        ])
        
        titleLabel.easy.layout([
            Top(16),
            Right(16),
            Left(16),
        ])
        
        image.easy.layout([
            Top(16).to(titleLabel),
            Left(16),
            Right(16),
            Height(200)
        ])
        
        summaryLabel.easy.layout([
            Top(16).to(image),
            Left(16),
            Right(16)
        ])
        
        buttonLink.easy.layout([
            Top(10).to(summaryLabel),
            Left(16),
            Right(16),
            Bottom(16)
        ])
    }
}

private extension DetailsViewController {
    
    func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        
        return scrollView
    }
    
    func makeContentViewScrollView() -> UIView {
        let view = UIView()
        
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        return titleLabel
    }
    
    func makeSummaryLabel() -> UILabel {
        let summaryLabel = UILabel()
        summaryLabel.numberOfLines = 0
        summaryLabel.textColor = .black
        summaryLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return summaryLabel
    }
    
    func makeImage() -> UIImageView {
        let imageArticle = UIImageView()
        
        return imageArticle
    }
    
    func makeButtonLink() -> UIButton {
        let btn = UIButton()
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 5
        btn.setTitle(LocalizedStrings.openArticle, for: .normal)
        return btn
    }
}
