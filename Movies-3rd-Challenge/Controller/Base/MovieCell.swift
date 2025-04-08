//
//  MovieCellTableViewCell.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 01.04.2025.
//

import UIKit
import Kingfisher // Для загрузки изображений

class MovieCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var currentMovie: Movie?
    private var genres: [String] = []
    static let identifier = "MovieCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont.systemFont(ofSize: 16, weight:.semibold)
        element.numberOfLines = 4
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var timeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clock")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var movieLengthLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont.systemFont(ofSize: 12)
        element.textColor = .gray
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()

    private lazy var calendarIcon: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "calendar")
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var yearLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont.systemFont(ofSize: 12)
        element.textColor = .gray
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var genreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.identifier)
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "FallbackCell"
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private lazy var filmIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "film")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = #colorLiteral(red: 0.7796905637, green: 0.8036449552, blue: 0.824585855, alpha: 1)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        
        contentView.addSubview(posterImageView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(timeIcon)
        contentView.addSubview(movieLengthLabel)
        
        contentView.addSubview(calendarIcon)
        contentView.addSubview(yearLabel)
        
        contentView.addSubview(filmIcon)
        contentView.addSubview(genreCollectionView)
        
        contentView.addSubview(favoriteButton)
        
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configure(with movie: Movie) {
        // Загружаем постер
        self.currentMovie = movie
        
        if let previewURL = movie.poster?.url, let url = URL(string: previewURL) {
                posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = UIImage(named: "posterNotFound")
        }
        
        titleLabel.text = movie.displayTitle
        
        if let year = movie.year {
            yearLabel.text = String(year)
        } else {
            yearLabel.text = ""
        }
         
        movieLengthLabel.text = movie.displayLength
        
        if let genresObjects = movie.genres {
            genres = genresObjects.compactMap {$0.name}
            genreCollectionView.reloadData()
        }
        
//        DispatchQueue.main.async {
//                self.genreCollectionView.collectionViewLayout.invalidateLayout()
//                self.contentView.layoutIfNeeded()
//            }
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
            guard let movie = currentMovie else { return }
            let isFavorite = TempDataManager.shared.isFavorite(movie)
            favoriteButton.isSelected = isFavorite
            favoriteButton.tintColor = isFavorite ? UIColor(named: "mainViolet") : .gray
        }
    
    @objc private func favoriteButtonTapped() {
        guard let movie = currentMovie else { return }
        
        if TempDataManager.shared.isFavorite(movie) {
            TempDataManager.shared.removeFromFavorites(movie)
        } else {
            TempDataManager.shared.addToFavorites(movie)
        }
        updateFavoriteButton()
    }
    
}

// MARK: - MovieCell Improvements
    
extension MovieCell {
     // Добавление закругленных углов
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalPriority, verticalFittingPriority: verticalFittingPriority)
        return CGSize(width: size.width + 32, height: size.height + 16)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Устанавливаем отступы для contentView
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        
        // Закругленные углы
        posterImageView.layer.cornerRadius = 12
        posterImageView.layer.masksToBounds = true
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MovieCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard genres.indices.contains(indexPath.row) else {
            print("Invalid index: \(indexPath.row), genres count: \(genres.count)")
            return createFallbackCell(for: genreCollectionView, at: indexPath)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.identifier, for: indexPath) as! GenreCell
        
        cell.configure(with: genres[indexPath.row])
        return cell
    }
    
    private func createFallbackCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let fallbackCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FallbackCell", for: indexPath)
        fallbackCell.backgroundColor = .systemRed.withAlphaComponent(0.1)
        fallbackCell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let errorLabel = UILabel()
        errorLabel.text = "Error"
        errorLabel.textColor = .white
        errorLabel.textAlignment = .center
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        fallbackCell.contentView.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: fallbackCell.contentView.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: fallbackCell.contentView.centerYAnchor)
        ])
        
        return fallbackCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let genre = genres[indexPath.row]
        let width = genre.size(withAttributes: [.font: UIFont.systemFont(ofSize: 10)]).width + 20
        return CGSize(width: width, height: 24)
    }
}

// MARK: - Setup Contraints

extension MovieCell {
    private func setupConstraints() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        movieLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        genreCollectionView.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 120),
            posterImageView.heightAnchor.constraint(equalToConstant: 160),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            
            timeIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            timeIcon.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeIcon.widthAnchor.constraint(equalToConstant: 16),
            timeIcon.heightAnchor.constraint(equalToConstant: 16),
            movieLengthLabel.leadingAnchor.constraint(equalTo: timeIcon.trailingAnchor, constant: 4),
            movieLengthLabel.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor),
            
            calendarIcon.topAnchor.constraint(equalTo: timeIcon.bottomAnchor, constant: 8),
            calendarIcon.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            calendarIcon.widthAnchor.constraint(equalToConstant: 16),
            calendarIcon.heightAnchor.constraint(equalToConstant: 16),
            yearLabel.leadingAnchor.constraint(equalTo: calendarIcon.trailingAnchor, constant: 4),
            yearLabel.centerYAnchor.constraint(equalTo: calendarIcon.centerYAnchor),
            
            
            filmIcon.topAnchor.constraint(equalTo: calendarIcon.bottomAnchor, constant: 8),
            filmIcon.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            filmIcon.widthAnchor.constraint(equalToConstant: 16),
            filmIcon.heightAnchor.constraint(equalToConstant: 16),
            
            genreCollectionView.centerYAnchor.constraint(equalTo: filmIcon.centerYAnchor),
            genreCollectionView.leadingAnchor.constraint(equalTo: filmIcon.trailingAnchor, constant: 4),
            genreCollectionView.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            genreCollectionView.heightAnchor.constraint(equalToConstant: 24),
            
            
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 27),
            favoriteButton.heightAnchor.constraint(equalToConstant: 27)
        ])
    }
}
