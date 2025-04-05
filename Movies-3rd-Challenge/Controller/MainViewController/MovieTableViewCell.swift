//
//  MoviewTableVieeCell.swift
//  Movies-3rd-Challenge
//
//  Created by Anna Melekhina on 01.04.2025.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()

    private lazy var categoryLabel: UILabel = {
           let label = UILabel()
           label.font = .systemFont(ofSize: 13)
           label.textColor = .gray
           label.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(label)
           return label
       }()
    
    private lazy var timeLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 10)
        label.textColor = .label
            label.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(label)
            return label
        }()
    
    private lazy var timeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock.fill")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var heartButton: UIButton = {
           let button = UIButton()
           button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
           button.setImage(UIImage(systemName: "heart"), for: .normal)
           button.tintColor = .gray
           button.translatesAutoresizingMaskIntoConstraints = false
           button.addTarget(self, action: #selector(toggleHeart), for: .touchUpInside)
           contentView.addSubview(button)
           return button
       }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        contentView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .boldSystemFont(ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        ratingLabel.textColor = .systemYellow
        ratingLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(ratingLabel)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 60),
            posterImageView.heightAnchor.constraint(equalToConstant: 60),
            
            categoryLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            
            heartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            heartButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            heartButton.widthAnchor.constraint(equalToConstant: 24),
            heartButton.heightAnchor.constraint(equalToConstant: 24),
            
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ratingLabel.topAnchor.constraint(equalTo: heartButton.bottomAnchor, constant: 4),
            
            timeIcon.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            timeIcon.widthAnchor.constraint(equalToConstant: 14),
            timeIcon.heightAnchor.constraint(equalToConstant: 14),
            
            timeLabel.leadingAnchor.constraint(equalTo: timeIcon.trailingAnchor, constant: 4),
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
            
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(title: String, rating: String, imageURL: URL?, duration: String, category: String) {
        titleLabel.text = title
        ratingLabel.text = "⭐️ \(rating)"
        
        timeLabel.text = duration
        categoryLabel.text = category
        
        if let url = imageURL {
            loadImage(from: url, into: posterImageView)
        } else {
            posterImageView.image = UIImage(named: "miniPoster")
        }
    }
    
    func loadImage(from url: URL, into imageView: UIImageView) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
    
    @objc private func toggleHeart() {
        heartButton.isSelected.toggle()
        heartButton.tintColor = heartButton.isSelected ? UIColor(named: "mainViolet") : .gray
       }
}
