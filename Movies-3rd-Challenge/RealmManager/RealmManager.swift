//
//  RealmManager.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 08.04.2025.
//

import Foundation
import RealmSwift
import FirebaseAuth

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
    
    func getCurrentUserRealm() -> UserRealm? {
        guard let firebaseUser = Auth.auth().currentUser else {
            return nil
        }
        
        if let existingUser = realm.object(ofType: UserRealm.self, forPrimaryKey: firebaseUser.uid) {
            return existingUser
        } else {
            // Создаем нового пользователя если не найден
            let newUser = UserRealm(firebaseUserId: firebaseUser.uid)
            do {
                try realm.write {
                    realm.add(newUser)
                }
                return newUser
            } catch {
                print("Error creating user in Realm: \(error)")
                return nil
            }
        }
    }

    // MARK: - Favorites Management
    
    // Добавить фильм в избранное пользователя
    func addToFavorites(movie: Movie) {
        do {
            guard let user = getCurrentUserRealm() else { return }
                    
            try realm.write {
                //если у пользователя нет таблицы избранного, то создаем ее
                if user.favorites == nil {
                    user.favorites = FavoriteRealm()
                }
                
                // Проверяем, есть ли уже такой фильм в Realm
                if let existingMovie = realm.object(ofType: MovieRealm.self, forPrimaryKey: movie.id ?? 0) {
                    // Если фильм уже существует, добавляем ссылку на него
                    if !user.favorites!.docs.contains(existingMovie) {
                        user.favorites?.docs.append(existingMovie)
                    }
                } else {
                    // Если фильма нет в Realm, создаем новый
                    let movieRealm = MovieRealm(from: movie)
                    realm.add(movieRealm)
                    user.favorites?.docs.append(movieRealm)
                }
            }
        } catch {
            print("Error adding to favorites: \(error)")
        }
    }
    
    // Удалить фильм из избранного пользователя
    func removeFromFavorites(movieId: Int) {
        guard let user = getCurrentUserRealm() else { return }
                
        do {
            try realm.write {
                if let index = user.favorites?.docs.firstIndex(where: { $0.movieId == movieId }) {
                                    user.favorites?.docs.remove(at: index)
                }
            }
        } catch {
            print("Error removing from favorites: \(error)")
        }
    }
    
    // Получить все избранные фильмы пользователя
    func getAllFavorites() -> [Movie] {
        guard let user = getCurrentUserRealm(), let favorites = user.favorites else {
                    return []
                }
        return favorites.docs.map { $0.toModel() }
    }

    // Проверить, является ли фильм избранным для пользователя
    func isFavorite(movieId: Int) -> Bool {
        guard let user = getCurrentUserRealm() else { return false }
                
        return user.favorites?.docs.contains(where: { $0.movieId == movieId }) ?? false
    }
    
    // MARK: - Recent Watch Management
    
    // Добавить фильм в историю просмотров пользователя
    func addToRecentWatch(movie: Movie) {
        do {
            guard let user = getCurrentUserRealm() else { return }
                    
            try realm.write {
                if user.recentWatch == nil {
                    user.recentWatch = RecentWatchRealm()
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
    func getRecentWatchedMovies(limit: Int = 10) -> [Movie] {
        guard let user = getCurrentUserRealm(), let recentWatch = user.recentWatch else {
            return []
        }
        return recentWatch.docs.sorted(byKeyPath: "watchDate", ascending: false).map { $0.toModel() }
    }
    
    // Очистить историю просмотров пользователя
//    func clearRecentWatchHistory(userId: String) {
//        do {
//            guard let user = getUser(id: userId), let recentWatch = user.recentWatch else { return }
//            
//            try realm.write {
//                realm.delete(recentWatch.docs)
//            }
//        } catch {
//            print("Error clearing recent watch history: \(error)")
//        }
//    }
}

