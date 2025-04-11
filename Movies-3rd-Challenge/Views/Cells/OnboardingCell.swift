//
//  OnboardingCell.swift
//  Movies-3rd-Challenge
//
//  Created by Александр Семёнов on 31.03.2025.
//
import UIKit

// MARK: - Protocol for Cell Delegate

// Протокол для делегирования событий из ячейки онбординга
protocol OnboardingCellDelegate: AnyObject {
    // Вызывается при нажатии на кнопку продолжения
    func didTapContinueButton(at index: Int)
    
    // Вызывается при нажатии на кнопку начала использования приложения
    func didTapStartButton()
}

// MARK: - Onboarding Cell

// Ячейка для отображения одного слайда онбординга
final class OnboardingCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // Делегат для обработки событий ячейки
    weak var delegate: OnboardingCellDelegate?
    
    // Индекс пути этой ячейки в коллекции
    var indexPath: IndexPath?
    
    // Основной контейнер для всего содержимого
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Контейнер для изображений
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Основное изображение слайда
    private lazy var mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = false
        iv.layer.cornerRadius = 16
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // Дополнительное изображение слева (для последнего слайда)
    private lazy var leftImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.alpha = 0.5
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isHidden = true
        return iv
    }()
    
    // Дополнительное изображение справа (для последнего слайда)
    private lazy var rightImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.alpha = 0.5
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isHidden = true
        return iv
    }()
    
    // Карточка для отображения текстового содержимого
    private lazy var contentCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(white: 0.15, alpha: 1.0) : .white
        }
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Заголовок слайда
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Описание слайда
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Кнопка действия (Продолжить/Начать)
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .onboardingBG
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    // Инициализатор с фреймом
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    // Настройка пользовательского интерфейса и ограничений
    private func setupUI() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(imageContainerView)
        imageContainerView.addSubview(leftImageView)
        imageContainerView.addSubview(mainImageView)
        imageContainerView.addSubview(rightImageView)
        
        containerView.addSubview(contentCardView)
        contentCardView.addSubview(titleLabel)
        contentCardView.addSubview(descriptionLabel)
        contentCardView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            imageContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            imageContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            imageContainerView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.45),
            
            mainImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            mainImageView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 0.8),
            mainImageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.8),
            
            leftImageView.bottomAnchor.constraint(equalTo: contentCardView.topAnchor),
            leftImageView.trailingAnchor.constraint(equalTo: mainImageView.leadingAnchor, constant: -30),
            leftImageView.widthAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 0.6),
            leftImageView.heightAnchor.constraint(equalTo: mainImageView.heightAnchor, multiplier: 0.9),
            
            rightImageView.bottomAnchor.constraint(equalTo: contentCardView.topAnchor),
            rightImageView.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 30),
            rightImageView.widthAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 0.6),
            rightImageView.heightAnchor.constraint(equalTo: mainImageView.heightAnchor, multiplier: 0.9),
            
            contentCardView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -20),
            contentCardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            contentCardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            contentCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -56),
            
            titleLabel.widthAnchor.constraint(equalToConstant: 278),
            titleLabel.centerXAnchor.constraint(equalTo: contentCardView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentCardView.topAnchor, constant: 60),
            
            descriptionLabel.widthAnchor.constraint(equalToConstant: 279),
            descriptionLabel.centerXAnchor.constraint(equalTo: contentCardView.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            
            actionButton.centerXAnchor.constraint(equalTo: contentCardView.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 200),
            actionButton.heightAnchor.constraint(equalToConstant: 56),
            actionButton.bottomAnchor.constraint(equalTo: contentCardView.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Configuration
    
    // Настраивает ячейку с заданными данными
    // - Parameters:
    //   - image: Название основного изображения
    //   - additionalImages: Массив названий дополнительных изображений для последнего слайда
    //   - title: Заголовок слайда
    //   - description: Описание слайда
    //   - isLastCell: Флаг, указывающий является ли ячейка последним слайдом
    func configure(image: String, additionalImages: [String]? = nil, title: String, description: String, isLastCell: Bool) {
        mainImageView.image = UIImage(named: image)
        titleLabel.text = title
        descriptionLabel.text = description
        
        if let additionalImages = additionalImages, additionalImages.count >= 2 {
            leftImageView.image = UIImage(named: additionalImages[0])
            rightImageView.image = UIImage(named: additionalImages[1])
            mainImageView.clipsToBounds = true
            leftImageView.isHidden = false
            rightImageView.isHidden = false
            
            mainImageView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor,multiplier: 0.55).isActive = true
            mainImageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.8).isActive = true
            mainImageView.bottomAnchor.constraint(equalTo: contentCardView.topAnchor,constant: -38).isActive = true
            
        } else {
            leftImageView.isHidden = true
            rightImageView.isHidden = true
        }
        
        if isLastCell {
            actionButton.setTitle("Start".localized(), for: .normal)
        } else {
            actionButton.setTitle("Continue".localized(), for: .normal)
        }
    }
    
    // MARK: - Actions
    
    // Обработчик нажатия на кнопку действия
    @objc private func buttonTapped() {
        guard let indexPath = indexPath else { return }
        
        if indexPath.item == 2 { // Последний слайд
            delegate?.didTapStartButton()
        } else {
            delegate?.didTapContinueButton(at: indexPath.item)
        }
    }
    
    // Обновляет интерфейс при изменении темы системы
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            contentCardView.backgroundColor = UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? UIColor(white: 0.15, alpha: 1.0) : .white
            }
        }
    }
    
    // Сбрасывает состояние ячейки при повторном использовании
    override func prepareForReuse() {
        super.prepareForReuse()
        leftImageView.isHidden = true
        rightImageView.isHidden = true
    }
}
