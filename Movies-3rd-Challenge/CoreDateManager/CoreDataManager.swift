////
////  CoreDateManager.swift
////  Movies-3rd-Challenge
////
////  Created by Евгений on 02.04.2025.
////
//
//import CoreData
//import UIKit
//
//class CoreDataManager {
//    static let shared = CoreDataManager()
//    private init() {}
//    
//    
//    //MARK: Сохранение фильма в избранное
//    func saveMovie(favoriteMovie: Movie) {
//        
////        guard !favoriteMovie.name.isEmpty else {
////            print("У фильма должно быть имя")
////            return
////        }
//        
//        guard favoriteMovie.rating.kp >= 0 && favoriteMovie.rating.kp <= 10 else {
//            print("Рейтинг долэен быть 0 до 10")
//            return
//        }
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            print("Ошибка в app Delegate")
//            return
//        }
//        
//        let context = appDelegate.persistentContainer.viewContext
//        
//        let fetchRequest: NSFetchRequest<CoreDataMovie> = CoreDataMovie.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %d", favoriteMovie.id)
//        
//        do {
//            let existingMovies = try context.fetch(fetchRequest)
//            if !existingMovies.isEmpty {
//                print("Фильм уже в избранном")
//                return
//            }
//            var mygenres: [String] = []
//            for genre in favoriteMovie.genres {
//                mygenres.append(genre.name)
//            }
//            let coutnOfGenres: Int = mygenres.count
//            
//            let movie = CoreDataMovie(context: context)
//            movie.genresOne = coutnOfGenres >= 1 ? mygenres[0] : ""
//            movie.genresTwo = coutnOfGenres >= 2 ? mygenres[1] : ""
//            movie.genresThree = coutnOfGenres >= 3 ? mygenres[2] : ""
//            movie.genresFour = coutnOfGenres >= 4 ? mygenres[3] : ""
//            movie.id = Int32(favoriteMovie.id)
//            
//            if let length = favoriteMovie.movieLength {
//                movie.movieLength = Int32(length)
//            } else {
//                movie.movieLength = Int32(0)
//            }
//            movie.name = favoriteMovie.name
//            movie.poster = favoriteMovie.poster.previewUrl != nil ? favoriteMovie.poster.previewUrl : ""
//            movie.rating = favoriteMovie.rating.kp
//            movie.year = Int32(favoriteMovie.year)
//            
//            try context.save()
//            print("Movie saved")
//        } catch {
//            print("Error saving movie: \(error)")
//        }
//    }
//    
//    //MARK: Получение избранных фильмов
//    func fetchFavoritesMovies() -> [Movie] {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            print("Ошмбка в app Delegate")
//            return []
//        }
//        
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<CoreDataMovie> = CoreDataMovie.fetchRequest()
//        do {
//            let movies = try context.fetch(fetchRequest)
//            var resultMovies: [Movie] = []
//            for movie in movies {
//                let convertToMovie = Movie(id: Int(movie.id),
//                                           name: movie.name ?? "",
//                                           year: Int(movie.year),
//                                           movieLength: Int(movie.movieLength),
//                                           rating: Rating.init(kp: Double(movie.rating)),
//                                           poster: Poster(previewUrl: movie.poster),
//                                           genres: [Genre(name: movie.genresOne ?? ""),
//                                                    Genre(name: movie.genresTwo ?? ""),
//                                                    Genre(name: movie.genresThree ?? ""),
//                                                    Genre(name: movie.genresFour ?? "")])
//                resultMovies.append(convertToMovie)
//            }
//            
//            return resultMovies
//        } catch {
//            print("не получилось загрузить избранное")
//            return []
//        }
//    }
//    //MARK: УДаление фильма из избранного по id
//    
//    func deleteMovie(withId id: Int) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            print("Failed to get AppDelegate")
//            return
//        }
//        let context = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest: NSFetchRequest<CoreDataMovie> = CoreDataMovie.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
//        
//        do {
//            let movies = try context.fetch(fetchRequest)
//            if let movie = movies.first {
//                context.delete(movie)
//                try context.save()
//                print("Фильм удален из избранного")
//            } else {
//                print("Такого фильма нет в избранном")
//            }
//        } catch {
//            print("Что-то пошло не так: \(error)")
//        }
//    }
//    
//    //MARK: Проверка наличия фильма в избраном
//    func isMovieInFavorites(withId id: Int) -> Bool {
//        let favoritesMovies = fetchFavoritesMovies()
//        return favoritesMovies.contains(where: { $0.id == id })
//    }
//}
//
////let newMovie = Movie(id: 1, name: "12", year: 12, movieLength: 122, rating: Rating(kp: 2.0), poster: Poster(previewUrl: "123"), genres: [Genre(name: "12")])
////var work: Bool = false
////func asd() {
////    CoreDataManager.shared.saveMovie(favoriteMovie: newMovie)
////    work = CoreDataManager.shared.isMovieInFavorites(withId: 1)
////    print(work)
////}
