//
//  TopCell.swift
//  Movies-3rd-Challenge
//
//  Created by Anna Melekhina on 01.04.2025.
//

import UIKit

final class TopCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var gradient: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.image = UIImage(named: "gradientPoster")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelBackgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            view.layer.cornerRadius = 10
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
            return view
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(labelBackgroundView)
        labelBackgroundView.addSubview(categoryLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(gradient)
        contentView.bringSubviewToFront(labelBackgroundView)
        contentView.bringSubviewToFront(titleLabel)
        contentView.bringSubviewToFront(categoryLabel)

        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            gradient.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradient.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradient.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradient.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            labelBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            labelBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            labelBackgroundView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            labelBackgroundView.heightAnchor.constraint(equalToConstant: 20),
            
            categoryLabel.topAnchor.constraint(equalTo: labelBackgroundView.topAnchor, constant: 2),
            categoryLabel.leadingAnchor.constraint(equalTo: labelBackgroundView.leadingAnchor, constant: 8),

            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(title: String, category: String, imageURL: URL?) {
        titleLabel.text = title
        categoryLabel.text = category
        if let url = imageURL {
            loadImage(from: url, into: imageView)
        } else {
            imageView.image = UIImage(named: "placeholder")  
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
}
