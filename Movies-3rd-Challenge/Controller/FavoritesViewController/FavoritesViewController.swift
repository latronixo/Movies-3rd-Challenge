//
//  FavoritesViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Elina Kanzafarova on 01.04.2025.
//

import UIKit

class FavoritesViewController: MovieListController {

  
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        setTitleUpper(navItem: navigationItem, title: "Favorites")
        setupConstraints()
    }
    
    // MARK: - Data Management
    
    override func loadData(category: String = "Все") {
        movies = TempDataManager.shared.getFavorites()
    }
    
     override func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

