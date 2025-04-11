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
        
        //Проверяем, есть ли текущий пользователь в базе
        if let existingUser = realm.object(ofType: UserRealm.self, forPrimaryKey: firebaseUser.uid) {
            return existingUser
        } else {
            // Создаем нового пользователя если не найден
            print("firebaseUser.uid = \(firebaseUser.uid)")
            
            let newUser = UserRealm(firebaseUserId: firebaseUser.uid)
            do {
                try realm.write {
                    realm.add(newUser)
                    
                    // Проверяем, существует ли FavoriteRealm c данным id
//                    if realm.object(ofType: FavoriteRealm.self, forPrimaryKey: firebaseUser.uid) == nil {
//                        print(firebaseUser.uid)
//                        //если не существует, то создаем новую таблицу FavoriteRealm
//                        let favorites = FavoriteRealm(userId: firebaseUser.uid)
//                        realm.add(favorites)
//                        newUser.favorites = favorites
//                    } else {
//                        // а если существует, то закрепляем за пользователем уже существующую таблицу FavoriteRealm
//                        newUser.favorites = realm.object(ofType: FavoriteRealm.self, forPrimaryKey: firebaseUser.uid)
//                    }
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
                // Если у пользователя нет таблицы избранного, создаем её
                if user.favorites == nil {
                    let favorites = FavoriteRealm(userId: user.firebaseUserId)
                    user.favorites = favorites
                    realm.add(favorites)
                }

                guard let favorites = user.favorites else { return }
                
                // Проверяем, есть ли уже такой фильм в Realm
                if let existingFavorite = favorites.favoriteMovies.first(where: { $0.movie?.movieId == movie.id }) {
                    // Обновляем дату добавления
                    existingFavorite.addedDate = Date()
                      } else {
                          // Проверяем, есть ли фильм в базе данных Realm
                          let movieRealm: MovieRealm
                          if let existingMovie = realm.object(ofType: MovieRealm.self, forPrimaryKey: movie.id ?? 0) {
                              movieRealm = existingMovie
                          } else {
                              // Если фильма нет в базе, создаём его
                              let newMovieRealm = MovieRealm(from: movie)
                              realm.add(newMovieRealm)
                              movieRealm = newMovieRealm
                          }

                          // Создаем новый объект FavoriteMovieRealm
                          let favoriteMovie = FavoriteMovieRealm(movie: movieRealm, addedDate: Date())
                          favorites.favoriteMovies.append(favoriteMovie)
                      }
                  }
        } catch {
            print("Error adding to favorites: \(error)")
        }
    }
    
    // Удалить фильм из избранного пользователя
    func removeFromFavorites(movieId: Int) {
        guard let user = getCurrentUserRealm(), let favorites = user.favorites else { return }
                
        do {
            try realm.write {
                if let index = favorites.favoriteMovies.firstIndex(where: { $0.movie?.movieId == movieId }) {
                                favorites.favoriteMovies.remove(at: index)
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

        // Сортируем избранные фильмы по дате добавления, учитывая, что movie может быть nil
        // Сортируем избранные фильмы по дате добавления
        let sortedFavorites = favorites.favoriteMovies
            .compactMap { $0.movie } // Игнорируем объекты, где movie == nil
            .sorted(by: { (first: MovieRealm, second: MovieRealm) -> Bool in
                guard let firstDate = favorites.favoriteMovies.first(where: { $0.movie?.movieId == first.movieId })?.addedDate,
                      let secondDate = favorites.favoriteMovies.first(where: { $0.movie?.movieId == second.movieId })?.addedDate else {
                    return false
        }
        return firstDate > secondDate
        })
        
        return sortedFavorites.map { $0.toModel() }
    }

    // Проверить, является ли фильм избранным для пользователя
    func isFavorite(movieId: Int) -> Bool {
        guard let user = getCurrentUserRealm(), let favorites = user.favorites else { return false }
                
        return favorites.favoriteMovies.contains(where: { $0.movie?.movieId == movieId })
    }
    
    // MARK: - Recent Watch Management
    
    // Добавить фильм в историю просмотров пользователя
    func addToRecentWatch(movie: Movie) {
        guard let user = getCurrentUserRealm() else { return }
        
        do {
            try realm.write {
                //Создаем или находим фильм в Realm
                let movieRealm: MovieRealm
                if let existing = realm.object(ofType: MovieRealm.self, forPrimaryKey: movie.id ?? 0) {
                    movieRealm = existing
                } else {
                    movieRealm = MovieRealm(from: movie)
                    realm.add(movieRealm)
                }
                
                // Проверяем, есть ли этот фильм уже в истории
                if let existingItem = user.recentWatch?.items.first(where: { $0.movie?.movieId == movie.id }) {
                    // Обновляем дату последнего просмотра
                    existingItem.watchDate = Date()
                } else {
                    //создаем новую запись в истории
                    let watchedItem = RecentWatchItemRealm(movie: movieRealm)
                    
                    //добавляем в начало списка
                    user.recentWatch?.items.insert(watchedItem, at: 0)
                    
                    //ограничиваем историю
                    if let count = user.recentWatch?.items.count, count > 10 {
                        user.recentWatch?.items.removeLast()
                    }
                }
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
        return recentWatch.items.sorted(byKeyPath: "watchDate", ascending: false).compactMap {
            guard let movie = $0.movie?.toModel() else { return nil }
            return movie
        }
    }
}
