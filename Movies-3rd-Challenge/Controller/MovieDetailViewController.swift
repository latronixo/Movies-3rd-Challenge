//
//  TempMovieDetailViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 31.03.2025.
//
import UIKit
import Kingfisher
import AVKit
import AVFoundation

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
        setupView()
        setupNavigationBar()
        updateFavoriteButtonState()
        configure()
        setupCollectionView()
        setupButtons()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserverForLocalization()
        updateFavoriteButtonState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverForLocalization()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        mainView.backgroundColor = .systemBackground
    }
    
    private func setupNavigationBar() {
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
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(addToFavorite))
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.leftBarButtonItem = backButton
        navigationItem.hidesBackButton = true
 
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "iconColor")
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "iconColor")
    }
    
    private func setupCollectionView() {
        mainView.actorsCollectionView.delegate = self
        mainView.actorsCollectionView.dataSource = self
    }
    
    private func setupButtons() {
        mainView.showMoreButton.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
        mainView.wathchButton.addTarget(self, action: #selector(watchNowTapped), for: .touchUpInside)
    }
    
    // MARK: - Favorite Logic
    
    private func updateFavoriteButtonState() {
        guard let movieId = movie.id else {
            navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "iconColor")
            return
        }
        
        let isFavorite = RealmManager.shared.isFavorite(movieId: movieId)
        let heartImageName = isFavorite ? "heart.fill" : "heart"
        let heartImage = UIImage(systemName: heartImageName)?
            .withRenderingMode(.alwaysTemplate)
        
        navigationItem.rightBarButtonItem?.image = heartImage
        navigationItem.rightBarButtonItem?.tintColor = isFavorite ? .red : UIColor(named: "iconColor")
    }
    
    @objc private func addToFavorite(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        
        guard let movieId = movie.id else {
            sender.isEnabled = true
            return
        }
        
        let shouldAddToFavorites = !RealmManager.shared.isFavorite(movieId: movieId)
        
        DispatchQueue.main.async {
            if shouldAddToFavorites {
                RealmManager.shared.addToFavorites(movie: self.movie)
            } else {
                RealmManager.shared.removeFromFavorites(movieId: movieId)
            }
            sender.isEnabled = true
            self.updateFavoriteButtonState()
        }
    }
    
    // MARK: - Other Methods
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func watchNowTapped() {
        guard let videoURL = self.detail.videos?.trailers?.first?.url else {
            self.showAlert(title: "Ошибка", message: "У данного видео нет трейлера")
            return
        }
        RealmManager.shared.addToRecentWatch(movie: movie)
        print("\(videoURL)")
        let player = AVPlayer(url: URL(string: videoURL)!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    @objc private func showMoreTapped() {
        showMore.toggle()
        mainView.descriptionOfMovie.numberOfLines = showMore ? 0 : 3
        let title = showMore ? "Show Less".localized() : "Show More".localized()
        mainView.showMoreButton.setTitle(title, for: .normal)
    }
    
    func configure() {
        mainView.titleOfMovie.text = movie.displayTitle
        mainView.durationOfMovie.text = movie.displayLength
        mainView.categoryLabel.text = movie.displayGenre
        mainView.descriptionOfMovie.text = movie.description ?? "Нет описания"
        
        if let year = movie.year {
            mainView.dateOfMovie.text = "\(year)"
        }

        if let url = movie.posterURL {
            mainView.imageOfMovie.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }

        let rating = movie.rating?.kp ?? 0
        let fiveStarRating = rating / 2.0
        for (index, star) in mainView.stars.enumerated() {
            star.image = UIImage(systemName: index < Int(round(fiveStarRating)) ? "star.fill" : "star")
            star.tintColor = .systemYellow
        }
    }
    //MARK: ALERT
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CollectionView Extensions

extension TempMovieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension TempMovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                       numberOfItemsInSection section: Int) -> Int {
        return detail.persons?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionCell", for: indexPath) as? DetailCollectionCell,
              let actor = detail.persons?[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.nameOfactor.text = actor.name
        cell.professionOfactor.text = actor.profession
        
        if let urlString = actor.photo, let imageURL = URL(string: urlString) {
            cell.photoOfactor.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
        } else {
            cell.photoOfactor.image = UIImage(named: "posterNotFound")
        }
        
        return cell
    }
}

// MARK: - Localization

extension TempMovieDetailViewController {
    private func addObserverForLocalization() {
        NotificationCenter.default.addObserver(forName: LanguageManager.languageDidChangeNotification,
                                            object: nil,
                                            queue: .main) { [weak self] _ in
            self?.updateLocalizedText()
        }
    }

    private func removeObserverForLocalization() {
        NotificationCenter.default.removeObserver(self,
                                                name: LanguageManager.languageDidChangeNotification,
                                                object: nil)
    }

    @objc private func updateLocalizedText() {
        if let label = navigationItem.titleView as? UILabel {
            label.text = "Movie Detail".localized()
        }

        mainView.wathchButton.setTitle("Watch Now".localized(), for: .normal)
        mainView.storyLine.text = "Story Line".localized()
        mainView.titelOfActors.text = "Cast and Crew".localized()
        
        let showMoreTitle = showMore ? "Show Less".localized() : "Show More".localized()
        mainView.showMoreButton.setTitle(showMoreTitle, for: .normal)
    }
}
