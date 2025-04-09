//
//  Data Model.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 08.04.2025.
//

import Foundation
import RealmSwift

// MARK: - Класс пользователя
class Users: Object {
    @Persisted(primaryKey: true) var userId: String = UUID().uuidString  // уникальный идентификатор пользователя
    @Persisted var username: String = "defaultName"  // имя пользователя
    @Persisted var email: String = "default@email.com"  // имя пользователя
    
    @Persisted var favorites: Favorites?  // Связь с избранным
    @Persisted var recentWatch: RecentWatch?  // Связь с историей просмотров
}

// MARK: - Класс для избранного

class Favorites: Object {
    @Persisted(primaryKey: true) var id: Int = 1    //всегда один объект избранного
    @Persisted var docs = List<MovieRealm>()        // Список фильмов в избранном
    
    @Persisted var user: Users?
    
    convenience init(from model: MovieResponse) {
        self.init()
        docs.append(objectsIn: model.docs.map { MovieRealm(from: $0) })
    }
 }

// MARK: - Класс для последнего просмосмотренного

class RecentWatch: Object {
    @Persisted var docs = List<MovieRealm>()    // Список просмотренных фильмов
    @Persisted var watchDate = Date()           // Дата последнего просмотра
    
    //Связь с пользователем
    @Persisted var user: Users?
    
    convenience init(from model: MovieResponse) {
        self.init()
        docs.append(objectsIn: model.docs.map { MovieRealm(from: $0) })
        watchDate = Date()
    }
}

// MARK: - Основной класс для фильма

class MovieRealm: Object {
    @Persisted(primaryKey: true) var movieId: Int = 0
    @Persisted var name: String?
    @Persisted var descriptionKP: String?
    @Persisted var rating: RatingRealm?
    @Persisted var movieLength: Int = 0
    @Persisted var poster: PosterRealm?
    @Persisted var votes: VotesRealm?
    @Persisted var genres = List<GenreRealm>()
    @Persisted var year: Int = 0
    
    @Persisted var movieDetail: MovieDetailRealm?    // Связь с таблицей MovieDetail
    
    convenience init(from model: Movie) {
        self.init()
        movieId = model.id ?? 0
        name = model.name
        descriptionKP = model.description
        
        if let rating = model.rating {
            self.rating = RatingRealm(from: rating)
        }
        
        movieLength = model.movieLength ?? 0
        
        if let poster = model.poster {
            self.poster = PosterRealm(from: poster)
        }
        
        if let votes = model.votes {
            self.votes = VotesRealm(from: votes)
        }
        genres.append(objectsIn: (model.genres ?? []).map { GenreRealm(from: $0) })
        year = model.year ?? 0
    }
    
    func toModel() -> Movie {
        return Movie(
            id: movieId,
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

// подкласс для рейтинга
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

// подкласс для постера
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

// подкласс для голосов
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

// подкласс для жанра
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

// MARK: - Класс для MovieDetail
// (для списка актеров и трейлера)
class MovieDetailRealm: Object {
    @Persisted var movieId: Int? = 0
    @Persisted var persons = List<PersonRealm>()
    @Persisted var videos = List<VideosRealm>()
    
    @Persisted var movie: MovieRealm?

    convenience init(from model: MovieDetail) {
        self.init()
        movieId = model.id
        persons.append(objectsIn: (model.persons ?? []).map { PersonRealm(from: $0) } )
        if let videos = model.videos {
            self.videos.append(VideosRealm(from: videos))
        }
    }
}


// подкласс для актеров и съемочной группы
class PersonRealm: EmbeddedObject {
    @Persisted var photo: String?
    @Persisted var name: String?
    @Persisted var profession: String?
    
    convenience init(from model: Person) {
        self.init()
        photo = model.photo
        name = model.name
        profession = model.profession
    }
    
    func toModel() -> Person {
        return Person(photo: photo, name: name, profession: profession)
    }
}

// подкласс для трейлера
class VideosRealm: EmbeddedObject {
    @Persisted var trailers = List<TrailerRealm>()
    
    convenience init(from model: Videos) {
        self.init()
        
        trailers.append(objectsIn: (model.trailers ?? []).map { TrailerRealm(from: $0) } )
    }
    
    func toModel() -> Videos {
        return Videos(trailers: trailers.map { $0.toModel() } )
    }
}

// подкласс для видео трейлера
class TrailerRealm: EmbeddedObject {
    @Persisted var url: String?
    
    convenience init(from model: Trailer) {
        self.init()
        url = model.url
    }
    
    func toModel() -> Trailer {
        return Trailer(url: url)
    }
    
    func assign(from model: Trailer) {
        url = model.url
    }
}
