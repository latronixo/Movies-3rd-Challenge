//
//  Favorite.swift
//  favoritesScreen
//
//  Created by Elina Kanzafarova on 01.04.2025.
//
struct Movie {
    let id: Int
    let name: String
    let image: String
    let movieLength: Int
    let date: Int
    let genres: [String]
}

let movie1 = Movie(
    id: 1,
    name: "Luck",
    image: "luckImage",
    movieLength: 148,
    date: 2021,
    genres: ["Family"]
)

let movie2 = Movie(
    id: 2,
    name: "Fistful",
    image: "fistfulImage",
    movieLength: 145,
    date: 2020,
    genres: ["Action"]
)

let movie3 = Movie(
    id: 3,
    name: "Drifting Home",
    image: "driftingHomeImage",
    movieLength: 120,
    date: 2010,
    genres: ["Action"]
)
