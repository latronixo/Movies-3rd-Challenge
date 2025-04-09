//
//  Constatnts.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 03.04.2025.
//

import Foundation

enum Constants {
    static let genres = ["Все", "боевик", "приключения", "детектив", "фэнтези", "другие"]
}

struct GenreItem {
    let displayName: String
    let queryValue: String?
}

    // название для кнопок соответствует локализации, а запросы в сети остаются на рус
enum GenreProvider {
    static func genres(for language: String) -> [GenreItem] {
        switch language {
        case "ru":
            return [
                GenreItem(displayName: "Все", queryValue: nil),
                GenreItem(displayName: "Боевик", queryValue: "боевик"),
                GenreItem(displayName: "Приключения", queryValue: "приключения"),
                GenreItem(displayName: "Детектив", queryValue: "детектив"),
                GenreItem(displayName: "Фэнтези", queryValue: "фэнтези"),
                GenreItem(displayName: "Другие", queryValue: "другие"),
            ]
        case "en":
            return [
                GenreItem(displayName: "All", queryValue: nil),
                GenreItem(displayName: "Action", queryValue: "боевик"),
                GenreItem(displayName: "Adventure", queryValue: "приключения"),
                GenreItem(displayName: "Detective", queryValue: "детектив"),
                GenreItem(displayName: "Fantasy", queryValue: "фэнтези"),
                GenreItem(displayName: "Other", queryValue: "другие"),
            ]
        default:
            return genres(for: "en")
        }
    }
}

    // исопльзование для коллекции
//  let genres = GenreProvider.genres(for: LanguageManager.shared.currentLanguage)

