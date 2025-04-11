//////
//////  CommonFunctions.swift
//////  Movies-3rd-Challenge
//////
//////  Created by Валентин Картошкин on 03.04.2025.
//////
////

import UIKit

func setupCustomTitle(_ title: String, _ navigationItem: UINavigationItem) {
    
    let titleLabel = UILabel()
    titleLabel.attributedText = NSAttributedString(
        string: title,
        attributes: [
            .font: UIFont(name: "PlusJakartaSans-Bold", size: 18) ?? .systemFont(ofSize: 18)])
    
      if #available(iOS 13.0, *) {
          titleLabel.textColor = UIColor { traitCollection in
              return traitCollection.userInterfaceStyle == .dark ? .white : .black
          }
      } else {
          titleLabel.textColor = .black
      }
      
      navigationItem.titleView = titleLabel
      
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
          titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.7),
          titleLabel.heightAnchor.constraint(equalToConstant: 44)
      ])
  }
