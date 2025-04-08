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
        
        updateLocalizedText()
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

extension FavoritesViewController {
    private func addObserverForLocalization() {
        NotificationCenter.default.addObserver(forName: LanguageManager.languageDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateLocalizedText()
        }
    }
    
    private func removeObserverForLocalization() {
        NotificationCenter.default.removeObserver(self, name: LanguageManager.languageDidChangeNotification, object: nil)
    }
    
    @objc func updateLocalizedText() {
        setTitleUpper(navItem: navigationItem, title: "Favorites".localized())
    }
}
