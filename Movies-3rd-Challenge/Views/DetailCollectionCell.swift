//
//  DetailCollectionCell.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 07.04.2025.
//

import UIKit

class DetailCollectionCell: UICollectionViewCell {
    let photoOfactor: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let nameOfactor: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PlusJakartaSans-SemiBold", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let professionOfactor: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PlusJakartaSans-Medium", size: 10)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let stackOfLabel: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let stackOfView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView() {
        stackOfLabel.addArrangedSubview(nameOfactor)
        stackOfLabel.addArrangedSubview(professionOfactor)
        stackOfView.addArrangedSubview(photoOfactor)
        stackOfView.addArrangedSubview(stackOfLabel)
        contentView.addSubview(stackOfView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            photoOfactor.heightAnchor.constraint(equalToConstant: 40),
            photoOfactor.widthAnchor.constraint(equalToConstant: 40),
            
            stackOfView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackOfView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackOfView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackOfView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
