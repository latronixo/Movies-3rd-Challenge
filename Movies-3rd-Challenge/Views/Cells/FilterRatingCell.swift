//
//  FilterRatingCell.swift
//  Movies-3rd-Challenge
//
//  Created by Александр Семёнов on 03.04.2025.
//

import UIKit

// Ячейка для отображения рейтинга звездами в фильтре
class FilterRatingCell: UICollectionViewCell {
    // Идентификатор для повторного использования ячейки
    static let identifier = "FilterRatingCell"
    
    // Стек для размещения изображений звезд
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Переопределяем свойство isSelected для обновления внешнего вида при выборе
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    // Значение рейтинга (количество звезд)
    private var ratingValue: Int = 0
    
    // Инициализатор с фреймом
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Настройка пользовательского интерфейса
    private func setupUI() {
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        updateAppearance()
    }
    
    // Обновление внешнего вида ячейки в зависимости от состояния выбора
    private func updateAppearance() {
        if isSelected {
            contentView.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.8, alpha: 1.0) // Фиолетовый цвет как на скриншоте
            contentView.layer.borderWidth = 0
            for subview in stackView.arrangedSubviews {
                if let imageView = subview as? UIImageView {
                    imageView.tintColor = .white
                }
            }
        } else {
            contentView.backgroundColor = .systemBackground
            contentView.layer.borderWidth = 1
            for subview in stackView.arrangedSubviews {
                if let imageView = subview as? UIImageView {
                    imageView.tintColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0) // Золотой цвет для звезд
                }
            }
        }
    }
    
    // Настройка ячейки с заданным рейтингом
    // - Parameter rating: Количество звезд для отображения (от 1 до 5)
    func configure(with rating: Int) {
        // Удаляем существующие звезды
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        self.ratingValue = rating
        
        // Настраиваем стек для динамического размера
        stackView.spacing = 4
        
        // Добавляем новые звезды
        for _ in 0..<rating {
            let starImageView = UIImageView(image: UIImage(named: "starYellow"))
            starImageView.contentMode = .scaleAspectFit
            starImageView.tintColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0) // Золотой цвет для звезд
            
            // Устанавливаем фиксированный размер звезды
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 20),
                starImageView.heightAnchor.constraint(equalToConstant: 20)
            ])
            
            stackView.addArrangedSubview(starImageView)
        }
        
        updateAppearance()
    }
} 
