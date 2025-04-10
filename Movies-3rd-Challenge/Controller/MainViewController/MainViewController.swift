//
//  MainViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Anna Melekhina on 01.04.2025.
//

import UIKit

final class MainViewController: UIViewController {

    //MARK: ui elements
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private lazy var topCollectionView: UICollectionView = {
        let topLayout = ArcLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: topLayout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TopCell.self, forCellWithReuseIdentifier: "TopCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = UIColor(named: "mainViolet")
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private lazy var categoryCollectionView: UICollectionView = {
        let catLayout = UICollectionViewFlowLayout()
        catLayout.scrollDirection = .horizontal
        catLayout.minimumLineSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: catLayout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()

    private lazy var headerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarImageView, greetingStack])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        return imageView
    }()

    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "👋 Hello, " + username
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sloganLabel: UILabel = {
        let label = UILabel()
        label.text = "Only streaming movie lovers"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var greetingStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [greetingLabel, sloganLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var boxOfficeLabel: UILabel = {
        let label = UILabel()
        label.text = "Box Office"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.tintColor = UIColor(named: "mainViolet")
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(seeAllTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
#warning("не забыть подставить сюда имя и аватар из FB / из экрана Сеттингс через Notification")
    private var username = "Name"
    private var banners: [Movie] = []   // верхняя карусель
     var movies: [Movie] = [] // бокс офис
    
    private var genres: [GenreItem] = [] // жанры берем из массива с локализацикей
    private var selectedGenreIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        genres = GenreProvider.genres(for: LanguageManager.shared.currentLanguage)
        
        setupScrollView()
        setupUI()
        
        loadBannerMovies()
        loadBoxOfficeMovies(category: nil)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        
        updateLocalizedText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.reloadData()
        addObserverForLocalization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverForLocalization()
    }

    // MARK: private methods
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupUI() {
        
        navigationController?.isNavigationBarHidden = true
        
        contentView.addSubview(topCollectionView)
        contentView.addSubview(categoryCollectionView)
        contentView.addSubview(tableView)
        contentView.addSubview(pageControl)
        contentView.addSubview(headerStack)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(boxOfficeLabel)
        contentView.addSubview(seeAllButton)
        contentView.addSubview(activityIndicator)
        
            
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            topCollectionView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 0),
            topCollectionView.heightAnchor.constraint(equalToConstant: 300),
            topCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            pageControl.topAnchor.constraint(equalTo: topCollectionView.bottomAnchor, constant: 0),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 5),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            categoryCollectionView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 40),
            categoryCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            boxOfficeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            boxOfficeLabel.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 20),
            
            seeAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            seeAllButton.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 20),

            tableView.topAnchor.constraint(equalTo: boxOfficeLabel.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 500),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    @objc private func seeAllTapped() {
        guard let tabBarController = self.tabBarController else { return }

            tabBarController.selectedIndex = 0

            if let navVC = tabBarController.viewControllers?[0] as? UINavigationController,
               let searchVC = navVC.viewControllers.first as? SearchViewController {
                searchVC.updateWithBoxOffice(movies: self.movies)
            }
    }
}

// MARK: CollectionView

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            return min(banners.count, 10)
        } else {
            return genres.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCell
            let movie = banners[indexPath.item]
            cell.configure(
                title: movie.displayTitle,
                    category: movie.displayGenre,
                    imageURL: movie.posterURL
            )
                return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            let genre = genres[indexPath.item]
            cell.configure(title: genre.displayName)
            return cell
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == topCollectionView {
            let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
            pageControl.currentPage = page
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topCollectionView {
            return CGSize(width: 200, height: 280)
        } else {
            let title = genres[indexPath.item].displayName
            let width = (title as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width + 32

            return CGSize(width: width, height: 32)
        }
    }
}

// MARK: CollectionView Delegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topCollectionView {
            let selectedMovie = banners[indexPath.item]
            guard let id = selectedMovie.id else { return }
            
            NetworkService.shared.fetchMovieDetail(id: id) { [weak self] detail in
                guard let detail = detail else { return }
                DispatchQueue.main.async {
                    let vc = TempMovieDetailViewController(movie: selectedMovie, detail: detail)
                    vc.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.navigationController?.isNavigationBarHidden = false
                    self?.navigationItem.backButtonTitle = ""
                }
            }
        } else {
            // Для CategoryCell
            for i in 0..<categories.count {
                    let index = IndexPath(item: i, section: 0)
                    if let cell = collectionView.cellForItem(at: index) as? CategoryCell {
                        cell.isCellSelected = (index == indexPath)
                    }
                }
                
                // Обновляем выбранную категорию и делаем запрос
                let selectedCategory = genres[indexPath.item]
                let genre = selectedCategory.queryValue
                loadBoxOfficeMovies(category: genre)
            
        }
    }
}


// MARK: TableView BOX office

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        min(movies.count, 5)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < movies.count else {
                return UITableViewCell()
            }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        let movie = movies[indexPath.row]
        cell.configure(movie: movie)

        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        guard let id = movie.id else { return }
        
        NetworkService.shared.fetchMovieDetail(id: id) { [weak self] detail in
            guard let detail = detail else { return }
            DispatchQueue.main.async {
                let vc = TempMovieDetailViewController(movie: movie, detail: detail)
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
                self?.navigationController?.isNavigationBarHidden = false
                self?.navigationItem.backButtonTitle = ""
            }
        }
    }
}

// MARK: Network
extension MainViewController {
    private func loadBannerMovies() {
        NetworkService.shared.fetchMoviesCaruselHomeScreen(1, 10) { [weak self] movies in
            self?.banners = movies
            
            DispatchQueue.main.async {
                self?.topCollectionView.reloadData()

            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        let indexPath = IndexPath(item: 1, section: 0)
                        if movies.count > 1 {
                            self?.topCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                        }
                    }
        }
    }
    
    private func loadBoxOfficeMovies(category: String?) {
        activityIndicator.startAnimating()

        NetworkService.shared.fetchMoviesBoxOfficeHomeScreen(1, 20, category) { [weak self] films in
            self?.movies = films
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.movies = films
                self?.tableView.reloadData()
            }
        }
    }
}

extension MainViewController {
    
    private func addObserverForLocalization() {
        NotificationCenter.default.addObserver(forName: LanguageManager.languageDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateLocalizedText()
        }
    }
    
    private func removeObserverForLocalization() {
        NotificationCenter.default.removeObserver(self, name: LanguageManager.languageDidChangeNotification, object: nil)
    }
    
    func updateLocalizedText() {
        categoryLabel.text = "Category".localized()
        boxOfficeLabel.text = "Box Office".localized()
        seeAllButton.setTitle("See All".localized(), for: .normal)
        sloganLabel.text = "Streaming for movie lovers".localized()
        greetingLabel.text = "👋 Hello, ".localized() + username
        genres = GenreProvider.genres(for: LanguageManager.shared.currentLanguage)
        categoryCollectionView.reloadData()
    }
}



//#Preview { MainViewController()}
