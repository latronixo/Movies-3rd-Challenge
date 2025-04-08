//
//  Data Model.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 08.04.2025.
//

import Foundation
import RealmSwift

// Класс для избранного
class Favorites: Object {
    @Persisted var docs = List<MovieRealm>()
    
    convenience init(from model: MovieResponse) {
        self.init()
        docs.append(objectsIn: model.docs.map { MovieRealm(from: $0) })
    }
}

// Класс для последнего просмосмотренного
class RecentWatch: Object {
    @Persisted var docs = List<MovieRealm>()
    @Persisted var watchDate = Date()
    
    
    convenience init(from model: MovieResponse) {
        self.init()
        docs.append(objectsIn: model.docs.map { MovieRealm(from: $0) })
        watchDate = Date()
    }
}

// Основной класс для фильма
class MovieRealm: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var name: String?
    @Persisted var descriptionKP: String?
    @Persisted var rating: RatingRealm?
    @Persisted var movieLength: Int = 0
    @Persisted var poster: PosterRealm?
    @Persisted var votes: VotesRealm?
    @Persisted var genres = List<GenreRealm>()
    @Persisted var year: Int = 0
    
    convenience init(from model: Movie) {
        self.init()
        id = model.id ?? 0
        name = model.name
        descriptionKP = model.description
        if let rating = model.rating {
            self.rating?.assign(from: rating)
        }
        movieLength = model.movieLength ?? 0
        if let poster = model.poster {
            self.poster?.assign(from: poster)
        }
        if let votes = model.votes {
            self.votes?.assign(from: votes)
        }
        genres.append(objectsIn: (model.genres ?? []).map { GenreRealm(from: $0) })
        year = model.year ?? 0
    }
    
    func toModel() -> Movie {
        return Movie(
            id: id,
            name: name,
            description: descriptionKP,
            rating: rating?.toModel(),
            movieLength: movieLength,
            poster: poster?.toModel(),
            votes: votes?.toModel(),
            genres: genres.map { $0.toModel() },
            year: year
        )
    }
}

// Класс для рейтинга
class RatingRealm: EmbeddedObject {
    @Persisted var kp: Double? = 0.0
    
    convenience init(from model: Rating) {
        self.init()
        kp = model.kp ?? 0.0
    }
    
    func toModel() -> Rating {
        return Rating(kp: kp)
    }
    
    func assign(from model: Rating) {
        kp = model.kp ?? 0.0
    }
}

// Класс для постера
class PosterRealm: EmbeddedObject {
    @Persisted var url: String?
    
    convenience init(from model: Poster) {
        self.init()
        url = model.url
    }
    
    func toModel() -> Poster {
        return Poster(url: url)
    }
    
    func assign(from model: Poster) {
        url = model.url
    }
}

// Класс для голосов
class VotesRealm: EmbeddedObject {
    @Persisted var kp: Int = 0
    
    convenience init(from model: Votes) {
        self.init()
        kp = model.kp ?? 0
    }
    
    func toModel() -> Votes {
        return Votes(kp: kp)
    }
    
    func assign(from model: Votes) {
        kp = model.kp ?? 0
    }
}

// Класс для жанра
class GenreRealm: EmbeddedObject {
    @Persisted var name: String?
    
    convenience init(from model: Genre) {
        self.init()
        name = model.name
    }
    
    func toModel() -> Genre {
        return Genre(name: name)
    }
}
