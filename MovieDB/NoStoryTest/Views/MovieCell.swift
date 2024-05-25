//
//  MovieCell.swift
//  NoStoryTest
//
//  Created by Smagul Negmatov on 06.05.2024.
//

import UIKit
import SnapKit

class MovieCell: UITableViewCell {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func conf(movie: MovieTitle) {
        titleLabel.text = movie.title
        movieImage.image = movie.imageMovie
    }
    
    private func setupLayout() {
        let movieStackView = UIStackView()
        movieStackView.axis = .vertical
        movieStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(movieStackView)
        movieStackView.addSubview(movieImage)
        movieStackView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
//            movieStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//            movieStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
//            movieStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
//            movieStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
//            movieImage.heightAnchor.constraint(equalTo: movieStackView.heightAnchor, multiplier: 0.8),
//            movieImage.widthAnchor.constraint(equalTo: movieStackView.widthAnchor)
        ])
        
        movieStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.leading.equalTo(contentView.snp.leading).offset(30)
            make.trailing.equalTo(contentView.snp.trailing).offset(-30)
        }
        
        movieImage.snp.makeConstraints { make in
            make.top.equalTo(movieStackView.snp.top)
            make.width.equalTo(movieStackView.snp.width).inset(10)
            make.height.equalTo(movieStackView.snp.height).inset(20)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(movieImage.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
