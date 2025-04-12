//
//  OnboardingView.swift
//  Movies-3rd-Challenge
//
//  Created by Александр Семёнов on 31.03.2025.
//

import UIKit

// Основное представление для экрана онбординга
final class OnboardingView: UIView {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    // Фоновое изображение для экрана онбординга
    private lazy var onboardingBGImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "back1"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Methods
    
    // Настройка элементов пользовательского интерфейса
    private func setupUI() {
        backgroundColor = .onboardingBG
        
        addSubview(onboardingBGImageView)
    }
    
    // Настройка ограничений для элементов интерфейса
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            onboardingBGImageView.heightAnchor.constraint(equalToConstant: 255),
            onboardingBGImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34),
            onboardingBGImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            onboardingBGImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
        ])
    }
}
