//
//  TempDataManager.swift
//  Movies-3rd-Challenge
//
//  Created by Elina Kanzafarova on 08.04.2025.
//

import Foundation

class TempDataManager {
    static let shared = TempDataManager()
    
    private var viewedMovies: [Movie] = []
    private var favoriteMovies: [Movie] = []
    
    // MARK: - Recently Viewed
    func addToRecentlyViewed(_ movie: Movie) {
        if !viewedMovies.contains(where: { $0.id == movie.id }) {
            viewedMovies.insert(movie, at: 0)
        }
    }
    
    func getRecentlyViewed() -> [Movie] {
        return viewedMovies
    }
    
    // MARK: - Favorites
    func addToFavorites(_ movie: Movie) {
        if !favoriteMovies.contains(where: { $0.id == movie.id }) {
            favoriteMovies.append(movie)
        }
    }
    
    func removeFromFavorites(_ movie: Movie) {
        favoriteMovies.removeAll { $0.id == movie.id }
    }
    
    func getFavorites() -> [Movie] {
        return favoriteMovies
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        return favoriteMovies.contains { $0.id == movie.id }
    }
}
