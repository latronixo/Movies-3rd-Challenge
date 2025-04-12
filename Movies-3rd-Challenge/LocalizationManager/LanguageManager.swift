//
//  Extension + String.swift
//  Movies-3rd-Challenge
//
//  Created by Anna Melekhina on 07.04.2025.
//

import Foundation

struct LanguageManager {
    static let shared = LanguageManager()
        private let userDefaultsKey = "LocalizeUserDefaultKey"
        private let defaultLanguage = "en"
        
        // Уведомление о смене языка
        static let languageDidChangeNotification = Notification.Name("LanguageDidChangeNotification")
        
        var currentLanguage: String {
            return UserDefaults.standard.string(forKey: userDefaultsKey) ?? defaultLanguage
        }
        
        func setLanguage(_ language: String) {
            UserDefaults.standard.setValue(language, forKey: userDefaultsKey)
            refreshLanguage()
        }
        
        private func refreshLanguage() {
            NotificationCenter.default.post(name: LanguageManager.languageDidChangeNotification, object: nil)
        }
}

extension String {
    
    func localized() -> String {
        // Получаем текущий язык из локализации приложения
        let currentLanguage = LanguageManager.shared.currentLanguage
        
        // Попытка получить локализованную строку на текущем языке
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
           let languageBundle = Bundle(path: path) {
            let localizedString = languageBundle.localizedString(forKey: self, value: nil, table: nil)
            
            // Если строка найдена, возвращаем ее сразу
            if localizedString != self {
                return localizedString
            }
        }
        
        // Пробуем получить строку на английском, если текущий перевод не найден
        if currentLanguage != "en",  // Избегаем повторной загрузки, если текущий язык - английский
           let englishPath = Bundle.main.path(forResource: "en", ofType: "lproj"),
           let englishBundle = Bundle(path: englishPath) {
            return englishBundle.localizedString(forKey: self, value: nil, table: nil)
        }
        
        // Если ничего не найдено, возвращаем сам ключ
        return self
    }
}

struct Languages {
    static var currentLocale = Locale.current.language.languageCode?.identifier
}

enum Language: String, CaseIterable {
    case ru
    case en
   
    var name: String {
        switch self {
        case .ru: return "Русский"
        case .en: return "English"
        }
    }
}

