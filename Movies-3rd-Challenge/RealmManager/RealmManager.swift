//
//  RealmManager.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 08.04.2025.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    private var realm: Realm
    
    private init() {
        do {
            realm = try Realm()
            initializeFavorites()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }

    private func initializeFavorites() {
        // Проверяем, есть ли уже объект избранного
        if realm.objects(Favorites.self).first == nil {
            do {
                try realm.write {
                    let favorites = Favorites()
                    realm.add(favorites)
                }
            } catch {
                print("Error initializing favorites: \(error)")
            }
        }
    }
    
    // MARK: - Favorites Management
      
    // Добавить фильм в избранное
    func addToFavorites(movie: Movie) {
        do {
            try realm.write {
                guard let favorites = realm.objects(Favorites.self).first else {
                    // Это не должно происходить, так как мы инициализировали favorites
                    print("Favorites not initialized")
                    return
                }
                
                if let existingMovie = realm.object(ofType: MovieRealm.self, forPrimaryKey: movie.id) {
                    if !favorites.docs.contains(existingMovie) {
                        favorites.docs.append(existingMovie)
                    }
                } else {
                    let movieRealm = MovieRealm(from: movie)
                    favorites.docs.append(movieRealm)
                }
            }
        } catch {
            print("Error adding to favorites: \(error)")
        }
    }
    
    /// Удалить фильм из избранного
    func removeFromFavorites(movieId: Int) {
        do {
            try realm.write {
                if let favorites = realm.objects(Favorites.self).first {
                    if let index = favorites.docs.firstIndex(where: { $0.movieId == movieId }) {
                        favorites.docs.remove(at: index)
                    }
                }
            }
        } catch {
            print("Error removing from favorites: \(error)")
        }
    }
    
    /// Проверить, есть ли фильм в избранном
    func isFavorite(movieId: Int) -> Bool {
        guard let favorites = realm.objects(Favorites.self).first else { return false }
        return favorites.docs.contains(where: { $0.movieId == movieId })
    }
    
    /// Получить все избранные фильмы
    func getAllFavorites() -> [Movie] {
        guard let favorites = realm.objects(Favorites.self).first else { return [] }
        return favorites.docs.map { $0.toModel() }
    }
    
    // MARK: - Recent Watch Management
    
    /// Добавить фильм в историю просмотров
    func addToRecentWatch(movie: Movie) {
        do {
            try realm.write {
                // Создаем новую запись просмотра
                let movieResponse = MovieResponse(docs: [movie]) 
                let recentWatch = RecentWatch(from: movieResponse)
                
                // Удаляем старые записи, если их больше 20
                let allRecent = realm.objects(RecentWatch.self).sorted(byKeyPath: "watchDate", ascending: false)
                if allRecent.count >= 20 {
                    let objectsToDelete = allRecent[19..<allRecent.count]
                    realm.delete(objectsToDelete)
                }
                
                realm.add(recentWatch)
            }
        } catch {
            print("Error adding to recent watch: \(error)")
        }
    }
    
    /// Получить последние просмотренные фильмы
    func getRecentWatchedMovies(limit: Int = 10) -> [Movie] {
        let recentWatches = realm.objects(RecentWatch.self)
            .sorted(byKeyPath: "watchDate", ascending: false)
            .prefix(limit)
        
        return recentWatches.flatMap { $0.docs.map { $0.toModel() } }
    }
    
    /// Очистить историю просмотров
    func clearRecentWatchHistory() {
        do {
            try realm.write {
                let recentWatches = realm.objects(RecentWatch.self)
                realm.delete(recentWatches)
            }
        } catch {
            print("Error clearing recent watch history: \(error)")
        }
    }
    
    // MARK: - Helper Methods
    
    /// Удалить все данные (для тестирования)
    func clearAllData() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Error clearing all data: \(error)")
        }
    }
}
