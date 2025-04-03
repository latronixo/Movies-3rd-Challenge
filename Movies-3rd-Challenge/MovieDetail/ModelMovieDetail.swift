//
//  ModelMovieDetail.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 03.04.2025.
//

import Foundation

struct MoviewDetailResponse: Decodable {
    let id: Int
    let name: String
    let description: String?
    let rating: Rating
    let premiere: Premiere
    let poster: Poster
    let genres: [Genre]
    let persons: [Person]
}

struct Premiere: Decodable {
    let world: String
}

struct Person: Decodable {
    let photo: String?
    let name: String?
    let profession: String?
}
