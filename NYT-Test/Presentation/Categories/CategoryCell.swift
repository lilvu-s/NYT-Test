//
//  CategoryCell.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 04.07.2023.
//

import UIKit

final class CategoryCell: UITableViewCell {
    private var nameLabel: UILabel!
    private var dateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        nameLabel = UILabel()
        nameLabel.textColor = .black
        contentView.addSubview(nameLabel)
        
        dateLabel = UILabel()
        dateLabel.textColor = .gray
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        contentView.addSubview(dateLabel)
        
        accessoryType = .disclosureIndicator
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func configure(with category: Category) {
        nameLabel.text = category.name
        dateLabel.text = category.newestPublishedDate
    }
}
