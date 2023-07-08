//
//  BookDetailsViewController.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 06.07.2023.
//

import UIKit
import SafariServices

protocol BookDetailsViewControllerProtocol: AnyObject {
    func openBuyLink(_ link: String)
    func updateWithBookDetails(book: Book)
    func updateWithBookCover(image: UIImage)
}

final class BookDetailsViewController: UIViewController, BookDetailsViewControllerProtocol {
    private var presenter: BookDetailsPresenterProtocol?
    private var buyButtonTappedHandler: (() -> Void)?
    
    private var bookNameLabel: UILabel = UILabel()
    private var descriptionLabel: UILabel = UILabel()
    private var authorLabel: UILabel = UILabel()
    private var publisherLabel: UILabel = UILabel()
    private var bookImageView: UIImageView = UIImageView()
    private var rankLabel: UILabel = UILabel()
    private var buyButton: UIButton = UIButton()
    
    // MARK: - Initialization
    
    init(presenter: BookDetailsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        presenter?.fetchBookDetails()
        presenter?.fetchBookCover()
        
        setupViews()
        setupConstrains()
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        bookImageView = UIImageView()
        bookImageView.contentMode = .scaleToFill
        view.addSubview(bookImageView)
        
        bookNameLabel.textColor = .black
        bookNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        bookNameLabel.numberOfLines = 2
        view.addSubview(bookNameLabel)
        
        authorLabel.textAlignment = .left
        authorLabel.textColor = .black
        authorLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        authorLabel.numberOfLines = 0
        view.addSubview(authorLabel)
        
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = .black
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        
        publisherLabel.textAlignment = .left
        publisherLabel.textColor = .darkGray
        publisherLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        publisherLabel.numberOfLines = 0
        view.addSubview(publisherLabel)
        
        rankLabel.textAlignment = .right
        rankLabel.textColor = .black
        rankLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        rankLabel.numberOfLines = 0
        view.addSubview(rankLabel)
        
        buyButton.setTitle("BUY", for: .normal)
        buyButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        buyButton.backgroundColor = .black
        buyButton.layer.cornerRadius = 25
        buyButton.clipsToBounds = true
        view.addSubview(buyButton)
    }
    
    private func setupConstrains() {
        bookImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(350)
        }
        
        bookNameLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(bookNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
        }
        
        publisherLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.top.equalTo(bookNameLabel.snp.top).inset(2)
            make.right.equalToSuperview().inset(30)
        }
        
        buyButton.snp.makeConstraints { make in
            make.top.equalTo(publisherLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    func openBuyLink(_ link: String) {
        if let url = URL(string: link) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    func updateWithBookDetails(book: Book) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.bookNameLabel.text = book.title
            self.authorLabel.text = book.author
            self.descriptionLabel.text = book.description ?? "No description."
            self.publisherLabel.text = book.publisher
            self.rankLabel.text = "\(book.rank)"
            
            self.buyButtonTappedHandler = { [weak self] in
                if let buyLink = book.buyLinks.first {
                    self?.openBuyLink(buyLink.url.absoluteString)
                }
            }
        }
    }
    
    func updateWithBookCover(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.bookImageView.image = image
        }
    }
    
    // MARK: - Actions
    
    @objc private func buyButtonTapped() {
        buyButtonTappedHandler?()
    }
    
    deinit {
        print("BookDetailsViewController deinitialized")
    }
}
