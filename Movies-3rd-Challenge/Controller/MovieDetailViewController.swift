//
//  TempMovieDetailViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 31.03.2025.
//
import UIKit
import Kingfisher
import WebKit

class TempMovieDetailViewController: UIViewController {
    private let mainView: TempMovieDetailView = .init()
    private var movie: Movie
    private var detail: MovieDetail
    private var showMore: Bool = false
    private var webView: WKWebView?
    
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
        
        updateLocalizedText()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBarTitle("Movie Detail", navigationItem)
        
        addObserverForLocalization()
        updateFavoriteButtonState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverForLocalization()
        webView?.removeFromSuperview()
        webView = nil
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
        
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(addToFavorite))
        
//        navigationItem.titleView = titleLabel
        
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
    
    // MARK: - Video Playback
    
    @objc private func watchNowTapped() {
        RealmManager.shared.addToRecentWatch(movie: movie)
        
        guard let videoURL = self.detail.videos?.trailers?.first?.url else {
            self.showAlert(title: "Ошибка", message: "Трейлер не доступен")
            return
        }
//        let videoURL = "https://rutube.ru/video/18a647acb3a93c15a43e96b1bb9b8bf1/?playlist=374796" //Можно посмтреть симпсонов
        guard let makeURL = URL(string: videoURL) else {
            showAlert(title: "Ошибка", message: "Video URL not available")
            return
        }
        
        if let existingWebView = webView {
            existingWebView.isHidden = false
            view.bringSubviewToFront(existingWebView)
        } else {
            setupWebView(with: makeURL)
        }
    }
    
    private func setupWebView(with url: URL) {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        

        webView = WKWebView(frame: view.bounds, configuration: config)
        webView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView?.navigationDelegate = self

        addCloseButton()
        
        guard let webView = webView else { return }
        view.addSubview(webView)
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func addCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("×", for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        closeButton.backgroundColor = .darkGray.withAlphaComponent(0.7)
        closeButton.tintColor = .white
        closeButton.layer.cornerRadius = 15
        closeButton.frame = CGRect(x: view.bounds.width - 50, y: view.safeAreaInsets.top + 20, width: 30, height: 30)
        closeButton.addTarget(self, action: #selector(closeVideo), for: .touchUpInside)
        
        webView?.addSubview(closeButton)
        webView?.bringSubviewToFront(closeButton)
    }
    
    @objc private func closeVideo() {
        webView?.removeFromSuperview()
        webView = nil
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
        navigationItem.rightBarButtonItem?.tintColor = isFavorite ? UIColor(named: "mainViolet") : UIColor(named: "iconColor")
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
    
    // MARK: ALERT
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

// MARK: - WKNavigationDelegate
extension TempMovieDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Video loaded successfully")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showAlert(title: "Error", message: "Failed to load video: \(error.localizedDescription)")
        webView.removeFromSuperview()
        self.webView = nil
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
