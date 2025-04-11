////
////  CommonFunctions.swift
////  Movies-3rd-Challenge
////
////  Created by Валентин Картошкин on 03.04.2025.
////
//
import UIKit
//
//// Поднимаем заголовок выше стандартного положения
func setTitleUpper (_ navigationController: UINavigationController?,_ title: String, _ view: UIView) {
    
    
        view.viewWithTag(9999)?.removeFromSuperview()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.tag = 9999
        
        // Цвет текста
        if #available(iOS 13.0, *) {
            titleLabel.textColor = UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? .white : .black
            }
        } else {
            titleLabel.textColor = .black
        }
        
        // Размеры и позиционирование
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 44
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let totalNavBarHeight = navBarHeight + statusBarHeight
        
        titleLabel.frame = CGRect(
            x: 0,
            y: totalNavBarHeight - 60, // Поднимаем выше стандартного положения
            width: view.bounds.width,
            height: 44
        )
        
        view.addSubview(titleLabel)
        
        // Констрейнты для адаптации к разным устройствам
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: totalNavBarHeight - -25),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            titleLabel.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

