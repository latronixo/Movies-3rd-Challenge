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
    let year: Int?
    let movieLength: Int?
    let rating: Rating?
    let poster: Poster?
    let genres: [Genre]?
}

struct Rating: Decodable {
    let kp: Double?
}

struct Poster: Decodable {
    let previewUrl: String?
}

struct Genre: Decodable {
    let name: String?
}

// заглушка для верстки
let movie1 = Movie(id: 1,
                   name: "Luck",
                   year: 2021,
                   movieLength: 148,
                   rating: Rating(kp: 4.5),
                   poster: Poster(previewUrl: luckPreviewUrlPoster),
                   genres: [Genre(name: "Action"), Genre(name: "Drama"), Genre(name: "Animation"), Genre(name: "Melodrama")]
)

//Модель для поиска по с фильтрами по жанрам и рейтингу

