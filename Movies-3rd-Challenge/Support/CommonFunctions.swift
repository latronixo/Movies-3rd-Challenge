//
//  CommonFunctions.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 03.04.2025.
//

import UIKit

// Поднимаем заголовок выше стандартного положения
func setTitleUpper (navItem: UINavigationItem, title: String) {
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    titleLabel.textAlignment = .center
    titleLabel.sizeToFit()
    
    // Добавляем автоматическое изменение цвета текста
     if #available(iOS 13.0, *) {
         titleLabel.textColor = UIColor { traitCollection in
             return traitCollection.userInterfaceStyle == .dark ? .white : .black
         }
     } else {
         // Для старых версий iOS используем стандартные цвета
         titleLabel.textColor = .black
     }
    
    // Настройка положения (поднимаем на 30 пунктов)
//    let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
//    titleLabel.frame = CGRect(x: 0, y: -30, width: 200, height: 40) // Сдвиг вверх
    let titleView = UIView()
    titleView.addSubview(titleLabel)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: -30), 
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: titleView.trailingAnchor)
        ])
    
    navItem.titleView = titleView

}
