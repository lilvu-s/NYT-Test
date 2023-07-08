//
//  BookCell.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 04.07.2023.
//

import UIKit
import SnapKit

protocol BookCellProtocol: AnyObject {
    func bookCellDidTapBook(_ cell: BookCell)
}

final class BookCell: UICollectionViewCell {
    private var bookImageView: UIImageView = UIImageView()
    private var titleLabel: UILabel = UILabel()
    private var authorLabel: UILabel = UILabel()
    weak var delegate: BookCellProtocol?
    private var interactor: BooksInteractorProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        bookImageView.contentMode = .scaleToFill
        contentView.addSubview(bookImageView)
        
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        authorLabel.textAlignment = .left
        authorLabel.textColor = .black
        authorLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        authorLabel.numberOfLines = 2
        contentView.addSubview(authorLabel)
    }
    
    private func setupConstraints() {
        bookImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(250)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.bottom).offset(10)
            make.leading.equalTo(bookImageView.snp.leading)
            make.trailing.equalTo(bookImageView.snp.trailing)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(bookImageView.snp.trailing)
        }
    }
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.author
    }
    
    func configureImage(with image: UIImage) {
        bookImageView.image = image
    }
    
    @objc private func bookTapped() {
        delegate?.bookCellDidTapBook(self)
    }
}
