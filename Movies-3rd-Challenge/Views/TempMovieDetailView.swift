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
    
    lazy var imageOfMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Movie")
        imageView.layer.cornerRadius = 16
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
    
    //MARK: calendarStack
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
    //MARK: DurationStack
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
    //MARK: CategoryStack
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
    //MARK: StackForMiniElemets
    lazy var stackInfoMovie: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackOfDate, stackOfDuration, stackOfCategory])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 24
        return stackView
    }()
    //MARK: Stars
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
    
    //MARK: DescriptionStack
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
    
    lazy var descriptionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [storyLine, descriptionOfMovie, showMoreButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    //MARK: Collection
    lazy var layout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        return layout
    }()
    lazy var titelOfActors: UILabel = {
        let label = UILabel()
        label.text = "Актеры и прочие"
        label.textColor = .label
        label.font = UIFont(name: "PlusJakartaSans-SemiBold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var actorsCollectionView: UICollectionView = {
        let collection: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    lazy var actorsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titelOfActors, actorsCollectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    //MARK: Button
    
    lazy var wathchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Watch Now", for: .normal)
        button.backgroundColor = .button
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    init() {
        super.init(frame: .zero)
        makeStars()
        setView()
        setConstraint()
    }
    
    private func setView(){
        addSubview(imageOfMovie)
        addSubview(movieStack)
        addSubview(descriptionStack)
        addSubview(wathchButton)
        addSubview(actorsStack)
        actorsCollectionView.register(DetailCollectionCell.self, forCellWithReuseIdentifier: "DetailCollectionCell")
    }
    private func setConstraint(){
        NSLayoutConstraint.activate([
            imageOfMovie.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageOfMovie.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35),
            imageOfMovie.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            movieStack.topAnchor.constraint(equalTo: imageOfMovie.bottomAnchor, constant: -20),
            movieStack.widthAnchor.constraint(equalTo: widthAnchor),
            movieStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            descriptionStack.topAnchor.constraint(equalTo: movieStack.bottomAnchor, constant: 10),
            descriptionStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            
            actorsStack.topAnchor.constraint(equalTo: descriptionStack.bottomAnchor, constant: 10),
            actorsStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            actorsStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            
            wathchButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            wathchButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.07),
            wathchButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            wathchButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
