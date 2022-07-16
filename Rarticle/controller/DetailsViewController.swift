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
    private lazy var shareIcon: UIBarButtonItem = makeShareIcon(iconID: Constants.shareIconID)
    
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
        setUpNavigationController()
        buttonLink.addTarget(self, action: #selector(self.didTapOnLinkBtn), for: .touchUpInside)
        animations()
    }
    
    private func animations() {
        titleLabel.alpha = 0
        image.alpha = 0
        summaryLabel.alpha = 0
        buttonLink.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.titleLabel.alpha = 1.0
            self.image.alpha = 1.0
            self.summaryLabel.alpha = 1.0
            self.buttonLink.alpha = 1.0
        }
    }
    
    @objc private func didTapOnLinkBtn() {
        UIApplication.shared.open(URL(string: linkArticle)!)
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        scrollView.backgroundColor = Colors.backgroundDetailsScreenColor
        view.addSubview(scrollView)
        
        titleLabel.text = titleArticle
        summaryLabel.text = summaryArticle
        image.loadFrom(urlAdress: imageArticle)
        
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
    
    private func setUpNavigationController() {
        let backButtonImage = UIImage(named: Constants.backButtonID)
        let backItem = UIBarButtonItem()
        let navigationBar = navigationController?.navigationBar
        
        navigationItem.title = LocalizedStrings.detailsViewControllerNavigationTitle
        navigationItem.rightBarButtonItem = shareIcon
        
        navigationBar?.backIndicatorImage = backButtonImage
        navigationBar?.backIndicatorTransitionMaskImage = backButtonImage
        
        backItem.title = LocalizedStrings.articles
        navigationBar?.topItem?.backBarButtonItem = backItem
    }
    
    // TODO: Gives errors: https://stackoverflow.com/questions/71946700/uiactivityviewcontroller-and-presentviewcontroller-generating-numerous-errors
    @objc private func handleShareIcon() {
        let url = URL(string: linkArticle)
        let text = "Look at article!"
        let activity = UIActivityViewController(activityItems: [url, text], applicationActivities: nil)
        present(activity, animated: true)
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
        titleLabel.textColor = Colors.blackWhiteTextColor
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        return titleLabel
    }
    
    func makeSummaryLabel() -> UILabel {
        let summaryLabel = UILabel()
        summaryLabel.numberOfLines = 0
        summaryLabel.textColor = Colors.blackWhiteTextColor
        summaryLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return summaryLabel
    }
    
    func makeImage() -> UIImageView {
        let imageArticle = UIImageView()
        
        return imageArticle
    }
    
    func makeButtonLink() -> UIButton {
        let btn = UIButton()
        btn.backgroundColor = Colors.buttonBackgroundcolor
        btn.layer.cornerRadius = 5
        btn.setTitle(LocalizedStrings.openArticle, for: .normal)
        return btn
    }
    
    // TODO: Vragen of dit kan
    func makeShareIcon(iconID: String) -> UIBarButtonItem {
        let shareButton = UIButton(type: .custom)
        shareButton.setImage(UIImage(named: iconID), for: .normal)
        shareButton.easy.layout([
            Height(24),
            Width(24)
        ])
        
        shareButton.addTarget(self, action: #selector(handleShareIcon), for: .touchUpInside)
        return UIBarButtonItem(customView: shareButton)
    }
}
