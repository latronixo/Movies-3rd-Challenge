//
//  ModelSearch.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 01.04.2025.
//

import Foundation

// Модели данных
struct MovieResponse: Decodable {
    let docs: [Movie]
}

//модель для поиска по названию
struct Movie: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let rating: Rating?
    let movieLength: Int?
    let poster: Poster?
    let votes: Votes?
    let genres: [Genre]?
    let year: Int?
}

struct Rating: Decodable {
    let kp: Double?
}

struct Poster: Decodable {
    let url: String?
}

struct Votes: Decodable {
    let kp: Int?
}

struct Genre: Decodable {
    let name: String?
}

//модель для получения списка актеров и съемочной группы - для поиска по Id
struct MovieDetail: Decodable {
    let persons: [Person]?
    let videos: [Trailer]?
}

struct Person: Decodable {
    let photo: String?
    let name: String?
    let profession: String?
}

struct Trailer: Decodable {
    let url: String?
}

extension Movie {
    var displayTitle: String {
        return name ?? "Без названия"
    }

    var displayRating: String {
        return String(format: "%.1f", rating?.kp ?? 0.0)
    }

    var displayGenre: String {
        return genres?.first?.name ?? "Жанр"
    }

    var displayLength: String {
        guard let length = movieLength else { return "сериал" }
        return "\(length) мин"
    }

    var posterURL: URL? {
        guard let url = poster?.url else { return nil }
        return URL(string: url)
    }
}
