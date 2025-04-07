//
//  FavoritesViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Elina Kanzafarova on 01.04.2025.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 184
        return tableView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setDelegates()
        setupConstraints()
    }
    
    // MARK: - Private Properties
    
    private let movie1 = Movie(id: 1, name: "Luck", description: "wow", rating: Rating(kp: 3.5), movieLength: 146, poster: nil, votes: Votes(kp: 4), genres: [Genre(name: "Драма"), Genre(name: "Документальный"), Genre(name: "Полнометражный")], year: 1999)
    
    private lazy var favorites: [Movie] = [movie1, movie1, movie1, movie1, movie1, movie1,]
    
    // MARK: - Set Views
    
    private func setViews() {
        view.backgroundColor = .white
        
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
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else { fatalError() }
        
        let favoriteMovie = favorites[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: favoriteMovie)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let favoriteMovie = favorites[indexPath.row]
//        
//        let movieDetailVC = TempMovieDetailView(coder: favoriteMovie.id)
//        navigationController?.pushViewController(movieDetailVC, animated: true)
//    }
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
