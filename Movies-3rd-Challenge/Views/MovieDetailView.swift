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
    
    lazy var stackInfoMovie: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackOfDate, stackOfDuration, stackOfCategory])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    //MARK: Stars
    lazy var starStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
    
    lazy var stackOfInfo: UIStackView = {
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
    
    init() {
        super.init(frame: .zero)
        makeStars()
        setView()
        setConstraint()
    }
    
    private func setView(){
        
        
    }
    private func setConstraint(){
        
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
