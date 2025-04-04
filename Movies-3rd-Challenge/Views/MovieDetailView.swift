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
    
<<<<<<< HEAD:Movies-3rd-Challenge/Views/MovieDetailView.swift
//    lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.attributedText = NSAttributedString(
//            string: "Мой стильный заголовок",
//            attributes: [
//                .font: UIFont.boldSystemFont(ofSize: 18),
//                .foregroundColor: UIColor.red
//            ]
//        )
//        return label
//    }()
=======
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
        label.font = .systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
>>>>>>> 04d5b2c7afbc0227cc52190011b5061c43c2710f:Movies-3rd-Challenge/Views/TempMovieDetailView.swift
    
    //MARK: calendarStack
    lazy var calendarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .blue
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var dateOfMovie: UILabel = {
        let label = UILabel()
        label.text = "17 Sep 2021"
        label.font = .systemFont(ofSize: 12)
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
        imageView.tintColor = .blue
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var durationOfMovie: UILabel = {
        let label = UILabel()
        label.text = "148 Minutes"
        label.font = .systemFont(ofSize: 12)
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
        imageView.tintColor = .blue
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = "Action"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var stackOfCategory: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackOfDate, categoryLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.axis = .horizontal
        return stackView
    }()
    
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
<<<<<<< HEAD:Movies-3rd-Challenge/Views/MovieDetailView.swift
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
=======
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
>>>>>>> 04d5b2c7afbc0227cc52190011b5061c43c2710f:Movies-3rd-Challenge/Views/TempMovieDetailView.swift
    
    //MARK: DescriptionStack
    lazy var storyLine: UILabel = {
        let label = UILabel()
        label.text = "Story Line"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionOfMovie: UILabel = {
        let label = UILabel()
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Show More"
        label.numberOfLines = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackOfInfo: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [storyLine, descriptionOfMovie])
        stackView.translatesAutoresizingMaskIntoConstraints = false
<<<<<<< HEAD:Movies-3rd-Challenge/Views/MovieDetailView.swift
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
    
=======
        stackView.alignment = .leading
        stackView.spacing = 16
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
    
    
>>>>>>> 04d5b2c7afbc0227cc52190011b5061c43c2710f:Movies-3rd-Challenge/Views/TempMovieDetailView.swift
    init() {
        super.init(frame: .zero)
        makeStars()
        setView()
        setConstraint()
    }
    
    private func setView(){
<<<<<<< HEAD:Movies-3rd-Challenge/Views/MovieDetailView.swift
        
        
    }
    private func setConstraint(){
=======
        addSubview(imageOfMovie)
        addSubview(movieStack)
        addSubview(descriptionStack)
        addSubview(wathchButton)
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
            descriptionStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            
            wathchButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            wathchButton.heightAnchor.constraint(equalToConstant: 56),
            wathchButton.widthAnchor.constraint(equalToConstant: 181),
            wathchButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
>>>>>>> 04d5b2c7afbc0227cc52190011b5061c43c2710f:Movies-3rd-Challenge/Views/TempMovieDetailView.swift
        
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
