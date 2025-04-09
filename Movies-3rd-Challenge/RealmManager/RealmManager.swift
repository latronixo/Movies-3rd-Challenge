//
//  RealmManager.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 08.04.2025.
//

import Foundation
import RealmSwift

class CurrentUser {
    static var currentUserId: String?
    
    func getUserId() -> String? {
        return CurrentUser.currentUserId
    }
}

class RealmManager {
    
    static let shared = RealmManager()
    private var realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }

    // MARK: - User Management
    
    /// Создание или получение пользователя по ID
    func getUser(id: String) -> Users? {
        return realm.objects(Users.self).filter("id == %@", id).first
    }
    
    /// Создание нового пользователя
    func createUser(username: String) -> Users {
        let user = Users()
        user.username = username
        
        do {
            try realm.write {
                realm.add(user)
            }
        } catch {
            print("Error creating user: \(error)")
        }
        
        return user
    }

    // MARK: - Favorites Management
    
    // Добавить фильм в избранное пользователя
    func addToFavorites(userId: String, movie: Movie) {
        do {
            guard let user = getUser(id: userId) else { return }
            
            try realm.write {
                if user.favorites == nil {
                    user.favorites = Favorites()
                }
                
                let movieRealm = MovieRealm(from: movie)
                user.favorites?.docs.append(movieRealm)
            }
        } catch {
            print("Error adding to favorites: \(error)")
        }
    }
    
    // Удалить фильм из избранного пользователя
    func removeFromFavorites(userId: String, movieId: Int) {
        do {
            guard let user = getUser(id: userId), let favorites = user.favorites else { return }
            
            try realm.write {
                if let index = favorites.docs.firstIndex(where: { $0.movieId == movieId }) {
                    favorites.docs.remove(at: index)
                }
            }
        } catch {
            print("Error removing from favorites: \(error)")
        }
    }
    
    // Получить все избранные фильмы пользователя
    func getAllFavorites(userId: String) -> [Movie] {
        guard let user = getUser(id: userId), let favorites = user.favorites else { return [] }
        return favorites.docs.map { $0.toModel() }
    }

    // Проверить, является ли фильм избранным для пользователя
    func isFavorite(userId: String, movieId: Int) -> Bool {
        guard let user = getUser(id: userId), let favorites = user.favorites else { return false }
        return favorites.docs.contains(where: { $0.movieId == movieId })
    }
    
    // MARK: - Recent Watch Management
    
    // Добавить фильм в историю просмотров пользователя
    func addToRecentWatch(userId: String, movie: Movie) {
        do {
            guard let user = getUser(id: userId) else { return }
            
            try realm.write {
                if user.recentWatch == nil {
                    user.recentWatch = RecentWatch()
                }
                
                let movieRealm = MovieRealm(from: movie)
                user.recentWatch?.docs.append(movieRealm)
                user.recentWatch?.watchDate = Date()  // Обновляем дату последнего просмотра
            }
        } catch {
            print("Error adding to recent watch: \(error)")
        }
    }
    
    // Получить последние просмотренные фильмы пользователя
    func getRecentWatchedMovies(userId: String, limit: Int = 10) -> [Movie] {
        guard let user = getUser(id: userId), let recentWatch = user.recentWatch else { return [] }
        return recentWatch.docs.prefix(limit).map { $0.toModel() }
    }
    
    // Очистить историю просмотров пользователя
    func clearRecentWatchHistory(userId: String) {
        do {
            guard let user = getUser(id: userId), let recentWatch = user.recentWatch else { return }
            
            try realm.write {
                realm.delete(recentWatch.docs)
            }
        } catch {
            print("Error clearing recent watch history: \(error)")
        }
    }
}

