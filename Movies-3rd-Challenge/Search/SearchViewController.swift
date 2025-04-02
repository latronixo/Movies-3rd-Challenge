//
//  SearchViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 01.04.2025.
//

import UIKit
import Alamofire

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    private var searchText: String = "Павел"
    private var selectedGenre: String?
    private var movies: [Movie] = []
    private var isLoading = false
    private var currentPage = 1
    private let limit = 10
    private let apiKey = Constants.apiKey
    
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
        allButton.setTitle("All", for: .normal)
        allButton.setTitleColor(.systemBlue, for: .selected)
        allButton.addTarget(self, action: #selector(genreButtonTapped(_:)), for: .touchUpInside)
        allButton.isSelected = true
        
        let genres = ["боевик", "приключения", "комедия", "мелодрама", "криминал", "биография", "драма", "история", "документальный", "короткометражка", "музыка", "мультфильм", "фэнтези", "семейный", "фантастика", "триллер"]
        
        return [allButton] + genres.map { genre in
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
        tableView.rowHeight = 150
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
        setupGenres()
        fetchMovies()
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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
    private func fetchMovies() {
        guard !isLoading else { return }
        isLoading = true
        
        let parameters: [String: Any] = [
            "currentPage": currentPage,
            "limit": limit,
            "query": searchText == "" ? "Павел" : searchText,
            "genres": selectedGenre ?? ""
        ]
        //AF.request("https://api.kinopoisk.dev/v1.4/movie/search", method: .get, parameters: parameters).responseDecodable { response in debugPrint(response) }
        
        AF.request("https://api.kinopoisk.dev/v1.4/movie/search",
                       method: .get,
                       parameters: parameters,
                       headers: ["X-API-KEY": apiKey])
                .responseDecodable(of: MovieResponse.self) { [weak self] response in
                    guard let self = self else { return }
                    
                    self.isLoading = false
                    
                    switch response.result {
                    case .success(let value):
                        if self.currentPage == 1 {
                            self.movies = value.docs
                        } else {
                            self.movies.append(contentsOf: value.docs)
                        }
                        self.tableView.reloadData()
                        
                    case .failure(let error):
                        print("Error fetching movies: \(error)")
                    }
                }
    }
    
    // MARK: - Genre Button Actions
    @objc private func genreButtonTapped(_ sender: UIButton) {
        genreButtons.forEach { $0.isSelected = ($0 == sender) }
        
        if let title = sender.currentTitle {
            selectedGenre = (title == "All") ? nil : title
        }
        
        currentPage = 1
        movies.removeAll()
        tableView.reloadData()
        fetchMovies()
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
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Загружаем следующую страницу, если достигли конца списка
        if indexPath.row == movies.count - 1 && !isLoading {
            currentPage += 1
            fetchMovies()
        }
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == movies.count - 1 && !isLoading {
//            fetchMovies()
//        }
//    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        currentPage = 1
        movies.removeAll()
        tableView.reloadData()
        fetchMovies()
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
        fetchMovies()
    }

    // Метод для формирования параметров запроса
    private func requestParameters() -> Parameters {
    var params: Parameters = [
        "api_key": apiKey,
        "currentPage": String(currentPage)
    ]

    if !searchText.isEmpty {
        params["query"] = searchText
    }

    if let genre = selectedGenre, genre != "All" {
        params["with_genres"] = genre
    }

    return params
    }
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
             self.fetchMovies()
         } )
     
     present(alert, animated: true)
     }
}
