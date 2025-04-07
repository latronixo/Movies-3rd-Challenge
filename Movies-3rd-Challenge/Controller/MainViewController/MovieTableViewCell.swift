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

    private let categoryLabel: UILabel = {
           let label = UILabel()
           label.font = .systemFont(ofSize: 13)
           label.textColor = .gray
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    private let timeLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 10)
            label.textColor = .label
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private let timeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock.fill")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let heartButton: UIButton = {
           let button = UIButton()
           button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
           button.setImage(UIImage(systemName: "heart"), for: .normal)
           button.tintColor = .gray
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(categoryLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(timeIcon)
        contentView.addSubview(heartButton)
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        contentView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        ratingLabel.textColor = .systemYellow
        ratingLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(ratingLabel)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 80),
            
            categoryLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),

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
        
        heartButton.addTarget(self, action: #selector(toggleHeart), for: .touchUpInside)

    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(movie: Movie) {
        titleLabel.text = movie.name
        ratingLabel.text = "⭐️ " + NetworkService.shared.formatRatingToFiveScale(movie.rating?.kp)
        timeLabel.text = String(movie.movieLength ?? 100) + " мин."
        categoryLabel.text = movie.genres?[0].name ?? ""
        loadImage(from: movie.posterURL , into: posterImageView)
    }
    
    @objc private func toggleHeart() {
        heartButton.isSelected.toggle()
        heartButton.tintColor = heartButton.isSelected ? UIColor(named: "mainViolet") : .gray
       }
    
    func loadImage(from url: URL?, into imageView: UIImageView) {
        guard let url = url else {
                DispatchQueue.main.async {
                    imageView.image = UIImage(named: "gradientPoster")
                }
                return
            }
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(named: "gradientPoster")
                    }
                }
            }
    }
}
