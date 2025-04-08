//
//  GenreCell.swift
//  Movies-3rd-Challenge
//
//  Created by Elina Kanzafarova on 03.04.2025.
//

import UIKit

class GenreCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "GenreCell"
    
    // MARK: - UI
        
    private lazy var genreView: UIView = {
        let element = UIView()
        element.backgroundColor = #colorLiteral(red: 0.3195238709, green: 0.3043658733, blue: 0.7124469876, alpha: 1)
        element.layer.cornerRadius = 6
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var genreLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont.systemFont(ofSize: 10)
        element.textColor = .white
        element.textAlignment = .center
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(genreView)
        genreView.addSubview(genreLabel)
        
        setupConstraints()
    }

    func configure(with genreName: String) {
        genreLabel.text = genreName
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            genreView.widthAnchor.constraint(equalTo: genreLabel.widthAnchor, constant: 20),
            genreView.heightAnchor.constraint(equalToConstant: 24),
            
            genreLabel.centerXAnchor.constraint(equalTo: genreView.centerXAnchor),
            genreLabel.centerYAnchor.constraint(equalTo: genreView.centerYAnchor),
        ])
    }
}



