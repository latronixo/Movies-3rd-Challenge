//
//  CategoryCell.swift
//  Movies-3rd-Challenge
//
//  Created by Anna Melekhina on 01.04.2025.
//

let categories = Constants.genres

import UIKit

final class CategoryCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var isCellSelected: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func updateAppearance() {
        UIView.animate(withDuration: 0.2) {
            if self.isCellSelected {
                self.contentView.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.8, alpha: 1.0)
                self.titleLabel.textColor = .white
            } else {
                self.contentView.backgroundColor = .secondarySystemBackground
                self.titleLabel.textColor = .label
            }
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
        updateAppearance()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isCellSelected = false
    }
}
