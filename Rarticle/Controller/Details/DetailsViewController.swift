//
//  DetailsViewController.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 11/07/2022.
//

import Foundation
import UIKit
import EasyPeasy
import Resolver
import SafariServices

// TODO: Safariviewcontroller om article te openen
class DetailsViewController: UIViewController {
    
    private let titleArticle: String
    private let descriptionArticle: String
    private let imageArticle: String?
    private let linkArticle: String
    private let author: String?
    private let publishedAt: String
    private let backButtonTitle: String
    
    private lazy var scrollView: UIScrollView = makeScrollView()
    private lazy var contentView: UIView = makeContentViewScrollView()
    private lazy var titleLabel: UILabel = makeTitleLabel()
    private lazy var descriptionLabel: UILabel = makeDescriptionLabel()
    private lazy var image: UIImageView = makeImage()
    private lazy var buttonLink: UIButton = .makeButton(backgroundColor: Colors.buttonBackgroundcolor!, cornerRadius: 5, title: LocalizedStrings.openArticle)
    private lazy var shareIcon: UIBarButtonItem = makeShareIcon(iconID: Constants.shareIconID)
    private lazy var authorPublishedAtLabel: UILabel = makeAuthorPublishedAtLabel()
    
    @Injected private var dateFormatterService: DateFormatterService
    @Injected private var urlLinkService: URLLinkService
   
    internal init(titleArticle: String, descriptionArticle: String, imageArticle: String?, linkArticle: String, author: String?, publishedAt: String, backButtonTitle: String) {
        self.titleArticle = titleArticle
        self.descriptionArticle = descriptionArticle
        self.imageArticle = imageArticle
        self.linkArticle = linkArticle
        self.author = author
        self.publishedAt = publishedAt
        self.backButtonTitle = backButtonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupLayout()
        setupConstraints()
        setUpNavigationController()
        buttonLink.addTarget(self, action: #selector(self.didTapOnLinkBtn), for: .touchUpInside)
        animations()
    }
    
    private func animations() {
        titleLabel.alpha = 0
        image.alpha = 0
        descriptionLabel.alpha = 0
        buttonLink.alpha = 0
        authorPublishedAtLabel.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.titleLabel.alpha = 1.0
            self.image.alpha = 1.0
            self.descriptionLabel.alpha = 1.0
            self.buttonLink.alpha = 1.0
            self.authorPublishedAtLabel.alpha = 1.0
        }
    }
    
    private func setupLayout() {
        scrollView.backgroundColor = Colors.backgroundDetailsScreenColor
        view.addSubview(scrollView)
        
        titleLabel.text = titleArticle
        descriptionLabel.text = descriptionArticle
        authorPublishedAtLabel.text = "\(author ?? LocalizedStrings.noAuthor) \(dateFormatterService.dateFormatter(date: publishedAt))"
        image.image = UIImage(named: Constants.placeHolderImage)
        image.loadFrom(urlAdress: imageArticle, placeholder: Constants.placeHolderImage)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(buttonLink)
        contentView.addSubview(image)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(authorPublishedAtLabel)
    }
    
    private func setupConstraints() {
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
            Top(16).to(image),
            Right(16),
            Left(16),
        ])
        
        image.easy.layout([
            Top(16),
            Left(0),
            Right(0),
            Height(200)
        ])
        
        authorPublishedAtLabel.easy.layout([
            Top(16).to(titleLabel),
            Left(16),
            Right(16)
        ])
        
        descriptionLabel.easy.layout([
            Top(16).to(authorPublishedAtLabel),
            Left(16),
            Right(16)
        ])
        
        buttonLink.easy.layout([
            Top(10).to(descriptionLabel),
            Left(16),
            Right(16),
            Bottom(16)
        ])
        
        shareIcon.customView?.easy.layout(Size(24))
    }
    
    private func setUpNavigationController() {
        let backButtonImage = UIImage(named: Constants.backButtonID)
        let backItem = UIBarButtonItem()
        let navigationBar = navigationController?.navigationBar
        
        navigationItem.title = LocalizedStrings.detailsViewControllerNavigationTitle
        navigationItem.rightBarButtonItem = shareIcon
        
        navigationBar?.backIndicatorImage = backButtonImage
        navigationBar?.backIndicatorTransitionMaskImage = backButtonImage
        
        backItem.title = backButtonTitle
        navigationBar?.topItem?.backBarButtonItem = backItem
    }
    
    @objc private func didTapOnLinkBtn() {
//        urlLinkService.openUrl(link: linkArticle)
        if let url = URL(string: linkArticle) {
            let safariConfiguration = SFSafariViewController.Configuration()
            safariConfiguration.entersReaderIfAvailable = true
            
            let safariController = SFSafariViewController(url: url, configuration: safariConfiguration)
            present(safariController, animated: true)
        }
    }
        
    // TODO: Gives errors: https://stackoverflow.com/questions/71946700/uiactivityviewcontroller-and-presentviewcontroller-generating-numerous-errors
    @objc private func handleShareIcon() {
        let urlArticle = URL(string: linkArticle)
        let text = LocalizedStrings.shareArticleText
        let activity = UIActivityViewController(activityItems: [urlArticle!, text], applicationActivities: nil)
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
    
    func makeDescriptionLabel() -> UILabel {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = Colors.blackWhiteTextColor
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return descriptionLabel
    }
    
    func makeImage() -> UIImageView {
        let imageArticle = UIImageView()
        
        return imageArticle
    }
    
    func makeShareIcon(iconID: String) -> UIBarButtonItem {
        let shareButton = UIButton(type: .custom)
        shareButton.setImage(UIImage(named: iconID), for: .normal)
        shareButton.addTarget(self, action: #selector(handleShareIcon), for: .touchUpInside)
        
        return UIBarButtonItem(customView: shareButton)
    }
    
    func makeAuthorPublishedAtLabel() -> UILabel {
        let authorPublishedAtLabel = UILabel()
        authorPublishedAtLabel.numberOfLines = 0
        authorPublishedAtLabel.textColor = .lightGray
        authorPublishedAtLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        return authorPublishedAtLabel
    }
}