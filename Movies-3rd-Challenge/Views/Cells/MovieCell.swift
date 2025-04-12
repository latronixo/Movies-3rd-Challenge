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
    
    private var movie: Movie?
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
        element.font = UIFont(name: "PlusJakartaSans-Bold", size: 18)
        element.numberOfLines = 3
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

    private lazy var addFavoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = #colorLiteral(red: 0.7796905637, green: 0.8036449552, blue: 0.824585855, alpha: 1)
        button.addTarget(self, action: #selector(addFavoriteButtonTapped), for: .touchUpInside)
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
        
        contentView.addSubview(addFavoriteButton)
        
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configure(with movie: Movie) {
        // Загружаем постер
        self.movie = movie
        
        if let posterURL = movie.poster?.url, let url = URL(string: posterURL) {
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
        
        // Обновляем состояние кнопки избранного
        let isFavorite = RealmManager.shared.isFavorite(movieId: movie.id ?? 0)
        addFavoriteButton.isSelected = isFavorite
        addFavoriteButton.tintColor = isFavorite ? UIColor(named: "mainViolet") : .gray

    }
    
    // Логика добавления в избранное
    @objc func addFavoriteButtonTapped() {
        //блокируем кнопку
        addFavoriteButton.isUserInteractionEnabled = false
        
        // Получаем movie из конфигурации ячейки
         guard let tableView = self.superview as? UITableView,
               let indexPath = tableView.indexPath(for: self) else {
             return
         }
        
        //получаем movie в зависимости от типа контроллера
        var movie: Movie? = nil
        
         // Получаем контроллер, содержащий таблицу
        if let searchVC = tableView.delegate as? SearchViewController {
            movie = searchVC.movies[indexPath.row]
        } else if let favoritesVC = tableView.delegate as? FavoritesViewController {
            movie = favoritesVC.movies[indexPath.row]
            
            //если данная ячейка на экране избранного, то удаляем ее
            favoritesVC.movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if let recentVC = tableView.delegate as? MovieListController {
            movie = recentVC.movies[indexPath.row]
        }
        
        guard let movie = movie, let movieId = movie.id else { return }
        
        let shouldAddToFavorites = !RealmManager.shared.isFavorite(movieId: movieId)
        
        //анимация кнопки
        UIView.animate(withDuration: 0.2, animations: {
            self.addFavoriteButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.addFavoriteButton.transform = .identity
            }
        }
        
        //делаем сердце выбранным
        addFavoriteButton.isSelected = shouldAddToFavorites
        addFavoriteButton.tintColor = shouldAddToFavorites ? UIColor(named: "mainViolet") : .gray
        
        //Работа с Realm в фоне
        DispatchQueue.main.async {
            if shouldAddToFavorites {
                RealmManager.shared.addToFavorites(movie: movie)
            } else {
                RealmManager.shared.removeFromFavorites(movieId: movie.id ?? 0)
            }
        }
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
        addFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            genreCollectionView.trailingAnchor.constraint(equalTo: addFavoriteButton.leadingAnchor, constant: -8),
            genreCollectionView.heightAnchor.constraint(equalToConstant: 24),
            
            
            addFavoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addFavoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            addFavoriteButton.widthAnchor.constraint(equalToConstant: 27),
            addFavoriteButton.heightAnchor.constraint(equalToConstant: 27)
        ])
    }
}
