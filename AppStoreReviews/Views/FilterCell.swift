//
//  FilterCell.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 27/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
    private var ratingLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(rating: Int) {
        var stars = ""
        for _ in 0..<rating {
            stars += "⭐️"
        }
        ratingLabel.text = "\(stars)"
    }
    
    private func setupLabels() {
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = UIFont.italicSystemFont(ofSize: 18)
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true

        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.addArrangedSubview(ratingLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        accessoryType = selected ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
    }
}
