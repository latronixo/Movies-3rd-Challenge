//
//  ModelSearch.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 01.04.2025.
//

import UIKit
import Kingfisher // Для загрузки изображений

// Структура для хранения данных фильма
struct Movie: Decodable {
    let title: String
    let imageURL: URL
    let duration: String
    let releaseDate: String
    let genre: String
    var isFavorite: Bool
    
    private enum CodingKeys: String, CodingKey {
        case title
        case duration
        case releaseDate = "release_date"
        case genre
        case imageURL = "poster_path"
        case isFavorite = "favorite"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        duration = try container.decode(String.self, forKey: .duration)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        genre = try container.decode(String.self, forKey: .genre)
        
        // Для imageURL может потребоваться дополнительная логика
        let imagePath = try container.decode(String.self, forKey: .imageURL)
        imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)")!
        
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
}

// Структура ответа API
struct MovieResponse: Decodable {
    let results: [Movie]
    let page: Int
    let total_results: Int
    let total_pages: Int
    
    private enum CodingKeys: String, CodingKey {
        case results
        case page
        case total_results
        case total_pages
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        results = try container.decode([Movie].self, forKey: .results)
        page = try container.decode(Int.self, forKey: .page)
        total_results = try container.decode(Int.self, forKey: .total_results)
        total_pages = try container.decode(Int.self, forKey: .total_pages)
    }
}

// Расширения для форматирования данных
extension Movie {
    // Конвертирует длительность из секунд в формат "hh:mm"
    var formattedDuration: String {
        let minutes = Int(duration) ?? 0
        let hours = minutes / 60
        let mins = minutes % 60
        return String(format: "%02d:%02d", hours, mins)
    }
    
    // Конвертирует дату в читаемый формат
    var formattedReleaseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate) else { return "" }
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }
}
