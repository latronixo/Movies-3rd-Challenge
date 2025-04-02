//
//  MovieDetailView.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 01.04.2025.
//


import UIKit

class TempMovieDetailView: UIView {
    private let starCount: Int = 5
    private var stars: [UIImageView] = []
    
    lazy var imageOfMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Movie")
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleOfMovie: UILabel = {
        let label = UILabel()
        label.text = "Movie"
        label.font = .systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: calendarStack
    lazy var calendarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var dateOfMovie: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var stackOfDate: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [calendarImage, dateOfMovie])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    //MARK: DurationStack
    lazy var clockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var durationOfMovie: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackOfDuration: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [clockImage, durationOfMovie])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    //MARK: CategoryStack
    lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "film")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var stackOfCategory: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackOfDate, categoryLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    //MARK: StackForMiniElemets
    lazy var stackInfoMovie: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackOfDate, stackOfDuration, stackOfCategory])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    //MARK: Stars
    lazy var starStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var movieStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleOfMovie, stackInfoMovie, starStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    //MARK: DescriptionStack
    lazy var storyLine: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionOfMovie: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [storyLine, descriptionOfMovie])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    //MARK: Actors
    lazy var labelOfCollection: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var actorsCollectionView: UICollectionView = {
        let collectionView = UICollectionView()
        return collectionView
    }()
    
    lazy var actorsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelOfCollection, actorsCollectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    //MARK: Button
    
    lazy var wathchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Watch Now", for: .normal)
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
        addSubview(actorsStack)
        addSubview(wathchButton)
    }
    private func setConstraint(){
        NSLayoutConstraint.activate([
            imageOfMovie.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            imageOfMovie.heightAnchor.constraint(equalToConstant: 300),
            imageOfMovie.widthAnchor.constraint(equalToConstant: 224),
            
            movieStack.topAnchor.constraint(equalTo: imageOfMovie.bottomAnchor, constant: 24),
            movieStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
            movieStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
            
            descriptionStack.topAnchor.constraint(equalTo: movieStack.bottomAnchor, constant: 32),
            descriptionStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            descriptionStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -24),
            
            actorsStack.topAnchor.constraint(equalTo: descriptionStack.bottomAnchor, constant: 24),
            actorsStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            actorsStack.rightAnchor.constraint(equalTo: rightAnchor),
            
            wathchButton.topAnchor.constraint(equalTo: actorsStack.bottomAnchor, constant: 27),
            wathchButton.heightAnchor.constraint(equalToConstant: 56),
            wathchButton.widthAnchor.constraint(equalToConstant: 181)])
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func makeStars() {
        for _ in 0 ..< self.starCount {
            let starImage = UIImageView(image: UIImage(systemName: "star"))
            self.stars.append(starImage)
            self.starStack.addArrangedSubview(starImage)
        }
    }
}
