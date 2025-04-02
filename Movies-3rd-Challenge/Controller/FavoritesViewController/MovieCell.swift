//
//  FavoriteCell.swift
//  Movies-3rd-Challenge
//
//  Created by Elina Kanzafarova on 01.04.2025.
//

import UIKit

class MovieCell: UITableViewCell {
    
    // MARK: - Elements
    
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 20
        element.distribution = .fill
        element.contentMode = .scaleToFill
        element.alignment = .top
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var movieImage: UIImageView = {
        let element = UIImageView()
        element.layer.cornerRadius = 16
        element.clipsToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var infoStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var nameLabel: UILabel = {
        let element = UILabel()
        element.font = .systemFont(ofSize: 20, weight: .bold)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var timeStackView: UIStackView = {
        let element = UIStackView()
        element.distribution = .equalSpacing
        element.contentMode = .scaleToFill
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var timeIcon: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(systemName: "clock.fill")
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var timeLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Properties
    
    public func configure(with model: Movie) {
        nameLabel.text = model.name
        movieImage.image = UIImage(named: model.image)
        timeLabel.text = String(model.movieLength) + " Minutes"
    }
    
    // MARK: - Set Views
    
    private func setViews() {
        contentView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(movieImage)
        mainStackView.addArrangedSubview(infoStackView)
        
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(timeStackView)
        
        timeStackView.addArrangedSubview(timeIcon)
        timeStackView.addArrangedSubview(timeLabel)
    }
}

// MARK: - Setup Contraints

extension MovieCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            movieImage.widthAnchor.constraint(equalToConstant: 120),
            movieImage.heightAnchor.constraint(equalToConstant: 160),
        ])
    }
}
