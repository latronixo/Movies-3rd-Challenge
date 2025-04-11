//
//  FavoritesViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Elina Kanzafarova on 01.04.2025.
//

import UIKit


class FavoritesViewController: UIViewController {
    
    var movies: [Movie] = []
    
    //флаг для исключения повторного открытия MovieDetail
    private var isNavigatingToDetail = false


    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 184
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont(name: "PlusJakartaSans-Bold", size: 18)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationBarAppearanceSettings()
        titleLabel.text = "Favorites"
        self.navigationItem.titleView = titleLabel
        
        setViews()
        setDelegates()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        movies = RealmManager.shared.getAllFavorites()
        tableView.reloadData()
    }
    
    // MARK: - Set Views
    
    private func setViews() {
        view.backgroundColor = .systemBackground
        
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
    }
    
    // MARK: - Set Delegates
    
    private func setDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func navigationBarAppearanceSettings() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else { fatalError() }
        
        let favoriteMovie = movies[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: favoriteMovie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard !isNavigatingToDetail else { return } // Если переход уже выполняется, игнорируем повторное нажатие
        isNavigatingToDetail = true                 // Устанавливаем флаг
        
        let selectedMovie = movies[indexPath.item]
        guard let id = selectedMovie.id else {
            isNavigatingToDetail = false // Сбрасываем флаг при ошибке
            return
        }
        
        NetworkService.shared.fetchMovieDetail(id: id) { [weak self] detail in
            guard let detail = detail else {
                self?.isNavigatingToDetail = false // Сбрасываем флаг при ошибке
                return
            }
            DispatchQueue.main.async {
                let vc = TempMovieDetailViewController(movie: selectedMovie, detail: detail)
                vc.hidesBottomBarWhenPushed = true  //скрываем таббар
                self?.navigationController?.pushViewController(vc, animated: true)
                self?.isNavigatingToDetail = false // Сбрасываем флаг после завершения перехода
            }
        }
    }
}
// MARK: - Setup Constraints

extension FavoritesViewController {
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

