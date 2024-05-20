//
//  ThemeCell.swift
//  NoStoryTest
//
//  Created by Sultan on 20.05.2024.
//

import UIKit

class ThemeCell: UICollectionViewCell {
    
    private let themeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(themeLabel)
        NSLayoutConstraint.activate([
            themeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            themeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            themeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            themeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with theme: String) {
        themeLabel.text = theme
    }
}

