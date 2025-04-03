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
                   poster: Poster(previewUrl: "https://image.openmoviedb.com/kinopoisk-images/1773646/b3e1e427-5cba-4d47-9187-e939431d706a/x1000"),
                   genres: [Genre(name: "Action")]
)

//------------------------------------------------------------
//ИСПОЛЬЗОВАТЬ ПОЗЖЕ
// Расширения для форматирования данных
//extension Movie {
//    // Конвертирует длительность из секунд в формат "hh:mm"
//    var formattedDuration: String {
//        let minutes = movieLength
//        let hours = minutes / 60
//        let mins = minutes % 60
//        return String(format: "%02d:%02d", hours, mins)
//    }
//
//}



//МОДЕЛЬ 01/04/25
// Структура для хранения данных фильма
//struct Movie: Decodable {
//    let title: String
//    let imageURL: URL
//    let duration: String
//    let releaseDate: String
//    let genre: String
//    var isFavorite: Bool
//    
//    private enum CodingKeys: String, CodingKey {
//        case title
//        case duration
//        case releaseDate = "release_date"
//        case genre
//        case imageURL = "poster_path"
//        case isFavorite = "favorite"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        title = try container.decode(String.self, forKey: .title)
//        duration = try container.decode(String.self, forKey: .duration)
//        releaseDate = try container.decode(String.self, forKey: .releaseDate)
//        genre = try container.decode(String.self, forKey: .genre)
//        
//        // Для imageURL может потребоваться дополнительная логика
//        let imagePath = try container.decode(String.self, forKey: .imageURL)
//        imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)")!
//        
//        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
//    }
//}


//ЭТУ МОДЕЛЬ ПОСТРОИЛ Я
// Структура ответа API
//struct MovieResponse: Decodable {
//    let id: Int
//    let name: String
//    let year: Int
//    let movieLength: Int
//    let poster: Poster
//    let genres: [Genre]
//    
//}
//
//struct Poster: Decodable {
//    let previewUrl: URL
//}
//
//struct Genre: Decodable {
//    let name: String
//}

//неверная модель с results (галлюционации)
//struct MovieResponse: Decodable {
//    let results: [Movie]
//    let page: Int
//    let total_results: Int
//    let total_pages: Int
//    
//    private enum CodingKeys: String, CodingKey {
//        case results
//        case page
//        case total_results
//        case total_pages
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        results = try container.decode([Movie].self, forKey: .results)
//        page = try container.decode(Int.self, forKey: .page)
//        total_results = try container.decode(Int.self, forKey: .total_results)
//        total_pages = try container.decode(Int.self, forKey: .total_pages)
//    }
//}





