//
//  MovieDetailView.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 01.04.2025.
//

import UIKit

class TempMovieDetailView: UIView {
    private let starCount: Int = 5
    var stars: [UIImageView] = []
    
    // MARK: - Scroll View Setup
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - UI Elements
    lazy var imageOfMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Movie")
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleOfMovie: UILabel = {
        let label = UILabel()
        label.text = "Movie"
        label.textColor = .label
        label.font = UIFont(name: "PlusJakartaSans-Bold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Calendar Stack
    lazy var calendarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = UIColor(named: "iconColor")
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var dateOfMovie: UILabel = {
        let label = UILabel()
        label.text = "17 Sep 2021"
        label.font = UIFont(name: "Montserrat-Medium", size: 12)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackOfDate: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [calendarImage, dateOfMovie])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: - Duration Stack
    lazy var clockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = UIColor(named: "iconColor")
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var durationOfMovie: UILabel = {
        let label = UILabel()
        label.text = "148 Minutes"
        label.textColor = .label
        label.font = UIFont(name: "Montserrat-Medium", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackOfDuration: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [clockImage, durationOfMovie])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: - Category Stack
    lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "film")
        imageView.tintColor = UIColor(named: "iconColor")
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Medium", size: 12)
        label.text = "Action"
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackOfCategory: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieImage, categoryLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: - Info Stack
    lazy var stackInfoMovie: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackOfDate, stackOfDuration, stackOfCategory])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 24
        return stackView
    }()
    
    // MARK: - Stars
    lazy var starStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var movieStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleOfMovie, stackInfoMovie, starStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Description Stack
    lazy var storyLine: UILabel = {
        let label = UILabel()
        label.text = "Story Line"
        label.textColor = .label
        label.font = UIFont(name: "PlusJakartaSans-SemiBold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionOfMovie: UILabel = {
        let label = UILabel()
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Show More"
        label.numberOfLines = 3
        label.font = UIFont(name: "PlusJakartaSans-Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "discriptionSet")
        return label
    }()
    
    lazy var showMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Увидеть больше", for: .normal)
        button.setTitleColor(UIColor(named: "Button"), for: .normal)
        button.titleLabel?.font = UIFont(name: "PlusJakartaSans-Medium", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var titelOfActors: UILabel = {
        let label = UILabel()
        label.text = "Актеры и прочие"
        label.textColor = .label
        label.font = UIFont(name: "PlusJakartaSans-SemiBold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [storyLine, descriptionOfMovie, showMoreButton, titelOfActors])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Collection
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 50)
        return layout
    }()
    
    lazy var actorsCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return collection
    }()
    
    // MARK: - Button
    lazy var wathchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Watch Now", for: .normal)
        button.backgroundColor = .button
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        makeStars()
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        // Добавляем scrollView и contentView
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Добавляем все элементы в contentView
        contentView.addSubview(imageOfMovie)
        contentView.addSubview(movieStack)
        contentView.addSubview(descriptionStack)
        contentView.addSubview(actorsCollectionView)
        contentView.addSubview(wathchButton)
        
        actorsCollectionView.register(DetailCollectionCell.self, forCellWithReuseIdentifier: "DetailCollectionCell")
    }
    
    private func setupConstraints() {
        // Констрейнты для scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Констрейнты для contentView
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Констрейнты для остальных элементов
        NSLayoutConstraint.activate([
            imageOfMovie.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageOfMovie.heightAnchor.constraint(equalToConstant: 200),
            imageOfMovie.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageOfMovie.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            
            movieStack.topAnchor.constraint(equalTo: imageOfMovie.bottomAnchor, constant: 20),
            movieStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            movieStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionStack.topAnchor.constraint(equalTo: movieStack.bottomAnchor, constant: 20),
            descriptionStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            actorsCollectionView.topAnchor.constraint(equalTo: descriptionStack.bottomAnchor, constant: 20),
            actorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            wathchButton.topAnchor.constraint(equalTo: actorsCollectionView.bottomAnchor, constant: 30),
            wathchButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            wathchButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            wathchButton.heightAnchor.constraint(equalToConstant: 50),
            wathchButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func makeStars() {
        for _ in 0 ..< self.starCount {
            let starImage = UIImageView(image: UIImage(systemName: "star"))
            starImage.heightAnchor.constraint(equalToConstant: 16).isActive = true
            starImage.widthAnchor.constraint(equalToConstant: 16).isActive = true
            self.stars.append(starImage)
            self.starStack.addArrangedSubview(starImage)
        }
    }
}
