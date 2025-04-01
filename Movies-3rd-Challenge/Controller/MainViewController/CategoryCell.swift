//
//  CategoryCell.swift
//  Movies-3rd-Challenge
//
//  Created by Anna Melekhina on 01.04.2025.
//

let categories = ["All", "Action", "Adventure", "Mystery", "Comedy", "Romance"]

import UIKit

final class CategoryCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let bgView = UIView()

    var isCellSelected: Bool = false {
        didSet {
            updateCellState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgView.backgroundColor = UIColor.systemGray6
        bgView.layer.cornerRadius = 16
        contentView.addSubview(bgView)
        bgView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
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
    }
    
    private func updateCellState() {
        if isCellSelected {
            bgView.backgroundColor = UIColor(named: "mainViolet")
            titleLabel.textColor = UIColor.white
        } else {
            bgView.backgroundColor = UIColor.systemGray6
            titleLabel.textColor = .black
        }
    }
}
