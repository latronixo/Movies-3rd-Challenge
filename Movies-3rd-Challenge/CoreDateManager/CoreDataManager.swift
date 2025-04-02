//
//  CoreDateManager.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 02.04.2025.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    
    //MARK: Сохранение фильма в избранное
    func saveMovie(genres: String, id: Int, movieLength: Int, name: String, poster: String, raiting: Double, year: Int) {
        guard !name.isEmpty else {
            print("У фильма должно быть имя")
            return
        }
        
        guard raiting >= 0 && raiting <= 10 else {
            print("Рейтинг долэен быть 0 до 10")
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Ошмбка в app Delegate")
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CoreDataMovie> = CoreDataMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let existingMovies = try context.fetch(fetchRequest)
            if !existingMovies.isEmpty {
                print("Фильм уже в избранном")
                return
            }
            
            let movie = CoreDataMovie(context: context)
            movie.genres = genres
            movie.id = Int32(id)
            movie.movieLength = Int32(movieLength)
            movie.name = name
            movie.poster = poster
            movie.rating = raiting
            movie.year = Int32(year)
            
            try context.save()
            print("Movie saved")
        } catch {
            print("Error saving movie: \(error)")
        }
    }
    
    //MARK: Получение избранных фильмов
    func fetchFavoritesMovies() -> [CoreDataMovie] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Ошмбка в app Delegate")
            return []
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CoreDataMovie> = CoreDataMovie.fetchRequest()
        do {
            let movies = try context.fetch(fetchRequest)
            return movies
        } catch {
            print("не получилось загрузить избранное")
            return []
        }
    }
    //MARK: УДаление фильма из избранного по id
    
    func deleteMovie(withId id: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Failed to get AppDelegate")
            return
        }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<CoreDataMovie> = CoreDataMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let movies = try context.fetch(fetchRequest)
            if let movie = movies.first {
                context.delete(movie)
                try context.save()
                print("Фильм удален из избранного")
            } else {
                print("Такого фильма нет в избранном")
            }
        } catch {
            print("Что-то пошло не так: \(error)")
        }
    }
    
    //MARK: Проверка наличия фильма в избраном
    func isMovieInFavorites(withId id: Int) -> Bool {
        let favoritesMovies = fetchFavoritesMovies()
        return favoritesMovies.contains(where: { $0.id == id })
    }
}
