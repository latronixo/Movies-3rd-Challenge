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


//Модель для поиска по с фильтрами по жанрам и рейтингу

