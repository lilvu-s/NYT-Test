//
//  BookDetailsViewController.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 06.07.2023.
//

import UIKit

protocol BookDetailsViewControllerProtocol: AnyObject {
    func openBuyLink(_ link: String)
    func updateWithBookDetails(book: Book)
    func updateWithBookCover(image: UIImage)
}

class BookDetailsViewController: UIViewController, BookDetailsViewControllerProtocol {
    private var presenter: BookDetailsPresenterProtocol?
    
    private var bookNameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var authorLabel: UILabel!
    private var publisherLabel: UILabel!
    private var bookImageView: UIImageView!
    private var rankLabel: UILabel!
    private var buyButton: UIButton!
    
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
        
        bookNameLabel = UILabel()
        bookNameLabel.textColor = .black
        bookNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        bookNameLabel.numberOfLines = 2
        view.addSubview(bookNameLabel)
        
        authorLabel = UILabel()
        authorLabel.textAlignment = .left
        authorLabel.textColor = .black
        authorLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        authorLabel.numberOfLines = 0
        view.addSubview(authorLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = .black
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        
        publisherLabel = UILabel()
        publisherLabel.textAlignment = .left
        publisherLabel.textColor = .black
        publisherLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        publisherLabel.numberOfLines = 0
        view.addSubview(publisherLabel)
        
        rankLabel = UILabel()
        rankLabel.textAlignment = .left
        rankLabel.textColor = .black
        rankLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        rankLabel.numberOfLines = 0
        view.addSubview(rankLabel)
        
        buyButton = UIButton()
        buyButton.setTitle("Buy", for: .normal)
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        view.addSubview(buyButton)
    }
    
    private func setupConstrains() {
        bookImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(400)
        }
        
        bookNameLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(bookNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        publisherLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.top.equalTo(publisherLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        buyButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    func openBuyLink(_ link: String) {
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
        }
    }
    
    func updateWithBookCover(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.bookImageView.image = image
        }
    }
    
    // MARK: - Actions
    
    @objc private func buyButtonTapped() {}
}
