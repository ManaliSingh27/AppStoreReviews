//
//  HeaderView.swift
//  AppStoreReviews
//
//  Created by Manali Mogre on 30/08/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation
import UIKit

class HeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showTopOccuringWords(viewModel: HeaderViewModel, count: Int) {
        let words = viewModel.findMostCommonOccuringWords(count: count)
        setupLabels(commonWords: words)
    }
    
    private func setupLabels(commonWords: [String]) {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        
        guard commonWords.count > 0 else {
            return
        }
        let titleLabel = UILabel()
        titleLabel.text = "Top \(Constants.kNumberOfTopOccuringWords) Occuring Words"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        stack.addArrangedSubview(titleLabel)
        
        _ = commonWords.map { word in
            let label = UILabel()
            label.textColor = UIColor.gray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 18)
            label.numberOfLines = 1
            label.text = word
            stack.addArrangedSubview(label)
        }
    }
}
