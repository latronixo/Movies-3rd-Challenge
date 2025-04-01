//
//  ModelSearch.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 01.04.2025.
//

import UIKit
//import Kingfisher // Для загрузки изображений

// Структура для хранения данных фильма
struct Movie {
    let title: String
    let imageURL: URL
    let duration: String
    let releaseDate: String
    let genre: String
    var isFavorite: Bool
}

// Структура ответа API
struct MovieResponse: Decodable {
     let results: [Movie]
     let page: Int
     let total_results: Int
     let total_pages: Int
    init(from decoder: any Decoder) throws {
        <#code#>
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

// MARK: - Networking Helper
    extension SearchViewController {
     // Метод для очистки поиска
 private func clearSearch() {
 searchText = ""
 page = 1
 movies.removeAll()
 tableView.reloadData()
 fetchMovies()
 }
 
 // Метод для формирования параметров запроса
 private func requestParameters() -> Parameters {
 var params: Parameters = [
 "api_key": apiKey,
 "page": String(page)
 ]
 
 if !searchText.isEmpty {
 params["query"] = searchText
 }
 
 if let genre = selectedGenre, genre != "All" {
 params["with_genres"] = genre
 }
 
 return params
 }
}
    
// MARK: - UI Improvements
extension SearchViewController {
     // Добавление тени под tableView
     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         tableView.layer.shadowPath = UIBezierPath(rect: tableView.bounds).cgPath
         tableView.layer.shadowColor = UIColor.lightGray.cgColor
         tableView.layer.shadowOpacity = 0.3
         tableView.layer.shadowRadius = 5
         tableView.layer.shadowOffset = CGSize(width: 0, height: 5)
     }
}

// MARK: - Error Handling
extension SearchViewController {
 // Обработка ошибок API
 private func handleError(_ error: Error) {
 let alert = UIAlertController(title: "Ошибка",
 message: "Не удалось загрузить данные. Проверьте подключение к интернету.",
 preferredStyle: .alert)
 
 alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
 self.fetchMovies()
 })
 
 present(alert, animated: true)
 }
}

// MARK: - MovieCell Improvements
extension MovieCell {
 // Добавление закругленных углов
 override func layoutSubviews() {
 super.layoutSubviews()
 contentView.layer.cornerRadius = 12
 contentView.layer.masksToBounds = true
 }
 
 // Добавление отступов
 override var contentInsets: UIEdgeInsets {
 return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
 }
}
