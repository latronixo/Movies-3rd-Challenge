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

struct Movie: Decodable {
    let id: Int
    let name: String
    let year: Int
    let movieLength: Int
    let rating: Rating
    let poster: Poster
    let genres: [Genre]
}

struct Rating: Decodable {
    let kp: Double
}

struct Poster: Decodable {
    let previewUrl: String?
}

struct Genre: Decodable {
    let name: String
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

let luckPreviewUrlPoster = "https://image.openmoviedb.com/kinopoisk-images/1773646/b3e1e427-5cba-4d47-9187-e939431d706a/x1000"

//Модель для деталей о фильме

