//
//  OnboardingView.swift
//  Movies-3rd-Challenge
//
//  Created by Александр Семёнов on 31.03.2025.
//

import UIKit

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
    private lazy var onboardingBGImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "back1"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Methods
    private func setupUI() {
        backgroundColor = .onboardingBG
        
        addSubview(onboardingBGImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            onboardingBGImageView.heightAnchor.constraint(equalToConstant: 255),
            onboardingBGImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34),
            onboardingBGImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            onboardingBGImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
        ])
    }
}
