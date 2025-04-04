//
//  FilterCategoryCell.swift
//  Movies-3rd-Challenge
//
//  Created by Александр Семёнов on 03.04.2025.
//

import UIKit

// Ячейка для отображения категории в фильтре
class FilterCategoryCell: UICollectionViewCell {
    // Идентификатор для повторного использования ячейки
    static let identifier = "FilterCategoryCell"
    
    // Метка для отображения названия категории
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Переопределяем свойство isSelected для обновления внешнего вида при выборе
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
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
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        updateAppearance()
    }
    
    // Обновление внешнего вида ячейки в зависимости от состояния выбора
    private func updateAppearance() {
        if isSelected {
            contentView.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.8, alpha: 1.0) // Фиолетовый цвет как на скриншоте
            titleLabel.textColor = .white
            contentView.layer.borderWidth = 0
        } else {
            contentView.backgroundColor = .systemBackground
            titleLabel.textColor = .label
            contentView.layer.borderWidth = 1
        }
    }
    
    // Настройка ячейки с заданным названием категории
    func configure(with title: String) {
        titleLabel.text = title
        updateAppearance() // Вызываем обновление внешнего вида после установки текста
    }
} 
