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

protocol IDetailsController {
    func display(article: ArticleDetailsViewModel.ViewModel)
    func displayLocalization(articleButtonTitle: String, navigationItemTitle: String)
}

class DetailsViewController: UIViewController {
    
    // MARK: Properties
    private lazy var scrollView: UIScrollView = makeScrollView()
    private lazy var contentView: UIView = makeContentViewScrollView()
    private lazy var titleLabel: UILabel = makeTitleLabel()
    private lazy var descriptionLabel: UILabel = makeDescriptionLabel()
    private lazy var image: UIImageView = makeImage()
    private lazy var buttonLink: UIButton = .makeButton(backgroundColor: Colors.buttonBackgroundcolor!, cornerRadius: 5)
    private lazy var shareIcon: UIBarButtonItem = makeShareIcon(iconID: Constants.shareIconID)
    private lazy var authorPublishedAtLabel: UILabel = makeAuthorPublishedAtLabel()
    
    private var detailsInteractor: DetailsInteractor?
    
    init(article: Article, router: DetailsRouter) {
        super.init(nibName: nil, bundle: nil)
        self.detailsInteractor = DetailsInteractor(detailsPresenter: DetailsPresenter(detailsViewController: self), router: router)
        detailsInteractor?.handleInitialize(article: article)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupLayout()
        setupConstraints()
        setUpNavigationController()
        animations()
        buttonClicks()
        detailsInteractor?.handleLocalization()
    }
    
    // MARK: Animations
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
    
    // MARK: Setup constraints
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
    
    // MARK: Button clicks
    private func buttonClicks() {
        buttonLink.addTarget(self, action: #selector(self.didTapOnLinkBtn), for: .touchUpInside)
    }
}

// MARK: Factory
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
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        
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

// MARK: Setup
private extension DetailsViewController {
    
    private func setupLayout() {
        scrollView.backgroundColor = Colors.backgroundDetailsScreenColor
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(buttonLink)
        contentView.addSubview(image)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(authorPublishedAtLabel)
    }
    
    private func setUpNavigationController() {
        let backButtonImage = UIImage(named: Constants.backButtonID)
        let backItem = UIBarButtonItem()
        let navigationBar = navigationController?.navigationBar
        
        navigationItem.rightBarButtonItem = shareIcon
        
        navigationBar?.backIndicatorImage = backButtonImage
        navigationBar?.backIndicatorTransitionMaskImage = backButtonImage
        navigationBar?.topItem?.backBarButtonItem = backItem
    }
}

// MARK: User actions
private extension DetailsViewController {
    @objc private func didTapOnLinkBtn() {
        detailsInteractor?.handleDidTapLink()
    }
        
    @objc private func didTapShare() {
        detailsInteractor?.handleDidTapShareButton()
    }
}

extension DetailsViewController: IDetailsController {
    func display(article: ArticleDetailsViewModel.ViewModel) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        authorPublishedAtLabel.text = "\(article.author ) \(article.publishedAt)"
        image.loadFrom(urlAdress: article.image, placeholder: Constants.placeHolderImage)
    }
    
    func displayLocalization(articleButtonTitle: String, navigationItemTitle: String) {
        buttonLink.setTitle(articleButtonTitle, for: .normal)
        navigationItem.title = navigationItemTitle
    }
}
