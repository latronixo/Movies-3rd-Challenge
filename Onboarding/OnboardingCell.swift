//
//  OnboardingCell.swift
//  Movies-3rd-Challenge
//
//  Created by Александр Семёнов on 31.03.2025.
//
import UIKit

final class OnboardingCell: UICollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 2)
//        view.layer.shadowRadius = 10
//        view.layer.shadowOpacity = 0.1
        view.clipsToBounds = false // Отключаем обрезку содержимого
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = false
        iv.layer.cornerRadius = 20
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var viewForText: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let slideButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .onboardingBG
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(viewForText)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(slideButton) // Добавляем кнопку в контейнер
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 326),
            containerView.heightAnchor.constraint(equalToConstant: 660),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 338),
            
            viewForText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewForText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            viewForText.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            viewForText.heightAnchor.constraint(equalToConstant: 325),
            
            titleLabel.topAnchor.constraint(equalTo: viewForText.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            slideButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            slideButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            slideButton.widthAnchor.constraint(equalToConstant: 200),
            slideButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configure(image: String, title: String, description: String, isLastCell: Bool) {
        imageView.image = UIImage(named: image)
        titleLabel.text = title
        descriptionLabel.text = description
//        slideButton.isHidden = !isLastCell
    }
}
