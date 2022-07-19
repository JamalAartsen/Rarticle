//
//  DetailsViewController.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 11/07/2022.
//

import Foundation
import UIKit
import EasyPeasy

// TODO: Safariviewcontroller om article te openen
class DetailsViewController: UIViewController {
    
    let titleArticle: String
    let descriptionArticle: String
    let imageArticle: String?
    let linkArticle: String
    let author: String?
    let publishedAt: String
    
    private lazy var scrollView: UIScrollView = makeScrollView()
    private lazy var contentView: UIView = makeContentViewScrollView()
    private lazy var titleLabel: UILabel = makeTitleLabel()
    private lazy var descriptionLabel: UILabel = makeDescriptionLabel()
    private lazy var image: UIImageView = makeImage()
    private lazy var buttonLink: UIButton = makeButtonLink()
    private lazy var shareIcon: UIBarButtonItem = makeShareIcon(iconID: Constants.shareIconID)
    private lazy var authorPublishedAtLabel: UILabel = makeAuthorPublishedAtLabel()
   
    internal init(titleArticle: String, descriptionArticle: String, imageArticle: String?, linkArticle: String, author: String?, publishedAt: String) {
        self.titleArticle = titleArticle
        self.descriptionArticle = descriptionArticle
        self.imageArticle = imageArticle
        self.linkArticle = linkArticle
        self.author = author
        self.publishedAt = publishedAt
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
    
    @objc private func didTapOnLinkBtn() {
        UIApplication.shared.open(URL(string: linkArticle)!)
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        scrollView.backgroundColor = Colors.backgroundDetailsScreenColor
        view.addSubview(scrollView)
        
        titleLabel.text = titleArticle
        descriptionLabel.text = descriptionArticle
        authorPublishedAtLabel.text = "\(author ?? LocalizedStrings.noAuthor) \(dateFormatter(date: publishedAt))"
        image.image = UIImage(named: Constants.placeHolderImage)
        image.loadFrom(urlAdress: imageArticle, placeholder: Constants.placeHolderImage)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(buttonLink)
        contentView.addSubview(image)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(authorPublishedAtLabel)
        
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
        
        authorPublishedAtLabel.easy.layout([
            Top(16).to(image),
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
        
        backItem.title = LocalizedStrings.articles
        navigationBar?.topItem?.backBarButtonItem = backItem
    }
        
    // TODO: Gives errors: https://stackoverflow.com/questions/71946700/uiactivityviewcontroller-and-presentviewcontroller-generating-numerous-errors
    @objc private func handleShareIcon() {
        let urlArticle = URL(string: linkArticle)
        let text = LocalizedStrings.shareArticleText
        let activity = UIActivityViewController(activityItems: [urlArticle!, text], applicationActivities: nil)
        present(activity, animated: true)
    }
    
    private func dateFormatter(date: String) -> String {
        let regexPattern = try! NSRegularExpression(pattern: Constants.regexPatternAZ)
        let range = NSMakeRange(0, date.count)
        let newDate = regexPattern.stringByReplacingMatches(in: date, range: range, withTemplate: " ")
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = Constants.beforeDateFormat
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = Constants.afterDateFormat
        
        let showDate = inputFormatter.date(from: newDate)
        return outputFormatter.string(from: showDate!)
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
    
    func makeButtonLink() -> UIButton {
        let btn = UIButton()
        btn.backgroundColor = Colors.buttonBackgroundcolor
        btn.layer.cornerRadius = 5
        btn.setTitle(LocalizedStrings.openArticle, for: .normal)
        return btn
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
