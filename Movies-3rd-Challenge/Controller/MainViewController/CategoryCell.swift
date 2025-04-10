//
//  CategoryCell.swift
//  Movies-3rd-Challenge
//
//  Created by Anna Melekhina on 01.04.2025.
//

let categories = Constants.genres

import UIKit

final class CategoryCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let bgView = UIView()
    
    var isCellSelected: Bool = false {
        didSet {
            updateCellState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgView.backgroundColor = .systemBackground
        bgView.layer.borderColor = UIColor(named: "greyCell")?.withAlphaComponent(0.25).cgColor
        bgView.layer.borderWidth = 1
        bgView.layer.cornerRadius = 16
        contentView.addSubview(bgView)
        bgView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(named:"greyLabel")
        bgView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(title: String) {
        titleLabel.text = title
        updateCellState()
    }
    
    private func updateCellState() {
        if isCellSelected {
            bgView.backgroundColor = UIColor(named: "mainViolet")
            bgView.layer.borderColor = UIColor(named: "mainViolet")?.cgColor
            titleLabel.textColor = UIColor.white
        } else {
            bgView.backgroundColor = .systemBackground
            bgView.layer.borderColor = UIColor(named: "greyCell")?.withAlphaComponent(0.25).cgColor
            titleLabel.textColor = UIColor(named:"greyLabel")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isCellSelected = false
    }
}
