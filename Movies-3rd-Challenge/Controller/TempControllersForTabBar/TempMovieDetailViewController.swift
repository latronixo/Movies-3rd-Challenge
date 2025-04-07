//
//  TempMovieDetailViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 31.03.2025.
//
import UIKit
import Kingfisher

class TempMovieDetailViewController: UIViewController {
    private let mainView: TempMovieDetailView = .init()
    private var movie: Movie
    private var detail: MovieDetail
    private var showMore: Bool = false
    
    init(movie: Movie, detail: MovieDetail) {
           self.movie = movie
           self.detail = detail
           super.init(nibName: nil, bundle: nil)
       }
    
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .systemBackground
        //MARK: NAVIGATION BAR
        let backButton = UIBarButtonItem(
            image: UIImage(named: "Arrow Back"),
            style: .plain,
            target: self,
            action: #selector(backTapped))
        
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(
            string: "Movie Detail",
            attributes: [
                .font: UIFont(name: "PlusJakartaSans-Bold", size: 26) ?? .systemFont(ofSize: 26)])
        
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "suit.heart"),
            style: .plain,
            target: self,
            action: #selector(addToFavorite))
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.hidesBackButton = true
        
        configure()
        mainView.showMoreButton.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
        
        self.mainView.actorsCollectionView.delegate = self
        self.mainView.actorsCollectionView.dataSource = self

    }
    
    @objc func addToFavorite() {
        
    }
            
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func watchNowTapped() {
        
    }
    func configure() {
        let movie = self.movie
        mainView.titleOfMovie.text = movie.displayTitle
        mainView.durationOfMovie.text = movie.displayLength
        mainView.categoryLabel.text = movie.displayGenre
        mainView.descriptionOfMovie.text = movie.description ?? "Нет описания"
        
        if let year = movie.year {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            mainView.dateOfMovie.text = "\(year)"
        }

        if let url = movie.posterURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.mainView.imageOfMovie.image = image
                    }
                }
            }
        }

        let rating = movie.rating?.kp ?? 0
        let fiveStarRating = rating / 2.0
        for (index, star) in mainView.stars.enumerated() {
            star.image = UIImage(systemName: index < Int(round(fiveStarRating)) ? "star.fill" : "star")
            star.tintColor = .systemYellow
        }
    }
    
    @objc func showMoreTapped() {
        self.showMore.toggle()
        if self.showMore == true {
            mainView.descriptionOfMovie.numberOfLines = 0
            mainView.showMoreButton.setTitle("Скрыть", for: .normal)
        } else {
            mainView.descriptionOfMovie.numberOfLines = 3
            mainView.showMoreButton.setTitle("Показать", for: .normal)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension TempMovieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 150, height: 40)
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
    
}
extension TempMovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let actors = self.detail.persons else { return 0 }
        return actors.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionCell", for: indexPath) as? DetailCollectionCell else {
            return UICollectionViewCell()
        }
        
        guard let persons = self.detail.persons else {
            return UICollectionViewCell()
        }
        let actor = persons[indexPath.row]
        
        cell.nameOfactor.text = actor.name
        cell.professionOfactor.text = actor.profession

        configureImage(for: cell, with: actor.photo)
        
        return cell
    }

    private func configureImage(for cell: DetailCollectionCell, with urlString: String?) {
        if let urlString = urlString, let imageURL = URL(string: urlString) {
            cell.photoOfactor.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            cell.photoOfactor.image = UIImage(named: "posterNotFound")
        }
    }
    
    
}
