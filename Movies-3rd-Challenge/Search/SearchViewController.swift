//
//  SearchViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 01.04.2025.
//

import UIKit
import Kingfisher // Для загрузки изображений
import Alamofire

final class SearchViewController: UIViewController {
    
    private var searchText: String = ""
    private var selectedGenre: String?
    private var selectedRating: String?
    private var movies: [Movie] = []
    private var isLoading = false
    private var currentPage = 1
    private let limit = 10

    private let genresList = Constants.genres

    // Таймер для задержки поиска
    private var searchTimer: Timer?

    private let networkManager = NetworkService.shared
    private let apiKey = Secrets.apiKey

    // MARK: - UI Components
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск фильмов"
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var genreScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()

    private lazy var genreButtons: [UIButton] = {
        let allButton = UIButton(type: .system)
        allButton.setTitle("Все", for: .normal)
        allButton.setTitleColor(.systemBlue, for: .selected)
        allButton.addTarget(self, action: #selector(genreButtonTapped(_:)), for: .touchUpInside)
        allButton.isSelected = true
        
        
        return [allButton] + genresList.map { genre in
            let button = UIButton(type: .system)
            button.setTitle(genre, for: .normal)
            button.setTitleColor(.systemBlue, for: .selected)
            button.addTarget(self, action: #selector(genreButtonTapped(_:)), for: .touchUpInside)
            return button
        }
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.rowHeight = 184
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleUpper(navItem: navigationItem, title: "Search")
        
        view.backgroundColor = .white
        
        //убираем разделители между ячейками
        tableView.separatorStyle = .none

        setupUI()
        setupConstraints()
        setupGenres()
        //loadMovies()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(genreScroll)
        view.addSubview(tableView)
        
        genreButtons.forEach {
            genreScroll.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        genreScroll.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            genreScroll.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            genreScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            genreScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            genreScroll.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: genreScroll.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupGenres() {
        var currentX: CGFloat = 16
        
        genreButtons.forEach { button in
            button.frame = CGRect(x: currentX, y: 0, width: button.intrinsicContentSize.width + 32, height: 44)
            currentX += button.frame.width + 8
        }
        
        genreScroll.contentSize = CGSize(width: currentX, height: 44)
    }
    
    // MARK: - Networking
    private func loadMovies() {
        guard !isLoading else { return }
        isLoading = true
        
            networkManager.fetchMovies(currentPage, limit, searchText) { [weak self] newMovies in
                
                DispatchQueue.main.async {
                    
                    if self?.currentPage == 1 {
                        self?.movies = newMovies
                    } else {
                        self?.movies.append(contentsOf: newMovies)
                    }
                    
                    self?.isLoading = false
                    
                    self?.tableView.reloadData()
                }
            }
    }
    
    private func loadMoviesWithFilters() {
        guard !isLoading else { return }
        isLoading = true
        
        networkManager.fetchMovies(currentPage, limit, selectedGenre, selectedRating) { [weak self] newMovies in
                
                DispatchQueue.main.async {
                    
                    if self?.currentPage == 1 {
                        self?.movies = newMovies
                    } else {
                        self?.movies.append(contentsOf: newMovies)
                    }
                    
                    self?.isLoading = false
                    
                    self?.tableView.reloadData()
                }
            }
    }
    
    // MARK: - Genre Button Actions
    @objc private func genreButtonTapped(_ sender: UIButton) {
        genreButtons.forEach { $0.isSelected = ($0 == sender) }
        
        if let title = sender.currentTitle {
            selectedGenre = (title == "Все") ? nil : title
        }
        
        currentPage = 1
        movies.removeAll()
        loadMoviesWithFilters()
        tableView.reloadData()
    }

}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    //обработка события окончания пролистывания таблицы (каждый свайп вниз или вверх (закомментировал, потому что при разработке попусту тратит лимит на количество запросов в сутки. Если до защиты останется время, можно будет раскомментировать и проверить, работает или нет)
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        let lastSectionIndex = tableView.numberOfSections - 1
//        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
//        
//        if indexPath.section == lastSectionIndex &&
//           indexPath.row == lastRowIndex && !isLoading {
//            // Загружаем следующую страницу при прокрутке до последней ячейки
//            currentPage += 1
//            loadMovies()
//            print("подгружаю еще 10 фильмов, страничку \(currentPage)...")
//
//        }
//    }

}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //отменяем предыдущий таймер, если он был
        searchTimer?.invalidate()
        
        //устанавливаем новый таймер на 3 секунды
        searchTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) {
            [weak self] _ in
            guard let self = self else { return }
            
            self.searchText = searchText
            currentPage = 1
            movies.removeAll()
            tableView.reloadData()
            loadMovies()
        }
         
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

// MARK: - Networking Helper
extension SearchViewController {
    // Метод для очистки поиска
    private func clearSearch() {
        searchText = ""
        currentPage = 1
        movies.removeAll()
        tableView.reloadData()
        loadMovies()
    }

    // Метод для формирования параметров запроса
//    private func requestParameters() -> Parameters {
//    var params: Parameters = [
//        "api_key": apiKey,
//        "currentPage": String(currentPage)
//    ]
//
//    if !searchText.isEmpty {
//        params["query"] = searchText
//    }
//
//    if let genre = selectedGenre, genre != "Все" {
//        params["genres.name"] = genre
//    }
//
//    return params
//    }
}

// MARK: - UI Improvements
extension SearchViewController {
     // Добавление тени под tableView
     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         tableView.layer.shadowPath = UIBezierPath(rect: tableView.bounds).cgPath
         tableView.layer.shadowColor = UIColor.lightGray.cgColor
         tableView.layer.shadowOpacity = 0.3
         tableView.layer.shadowRadius = 5
         tableView.layer.shadowOffset = CGSize(width: 0, height: 5)
     }
}

// MARK: - Error Handling
extension SearchViewController {
     // Обработка ошибок API
     private func handleError(_ error: Error) {
         let alert = UIAlertController(title: "Ошибка",
         message: "Не удалось загрузить данные. Проверьте подключение к интернету.", preferredStyle: .alert)
         
         alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
             self.loadMovies()
         } )
     
     present(alert, animated: true)
     }
}
