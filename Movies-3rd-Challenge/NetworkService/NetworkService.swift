import Foundation

class NetworkService {
    
    private let searchMoviesURLString = "https://api.kinopoisk.dev/v1.4/movie/search"
    private let universalSearchMoviesURLString = "https://api.kinopoisk.dev/v1.4/movie"
    private let movieDetailURLString = "https://api.kinopoisk.dev/v1.4/movie/"
    private let apiKey = ""
    private var currentTask: URLSessionTask?
    
    static let shared = NetworkService()
    
    private init() {}
    
    private let session: URLSession = .shared
    
    // MARK: - поиск по названию
    
    func fetchMovies(_ currentPage: Int, _ searchText: String, completion: @escaping ([Movie]) -> Void) {
        
        // Создаем базовые компоненты URL
        var urlComponents = URLComponents(string: searchMoviesURLString)
        
        //создаем массив для query items. Для поиска по названию нельзя установить параметр notNullFields или задать список требуемых полей
        let queryItems = [
            URLQueryItem(name: "page", value: String(currentPage)),
            URLQueryItem(name: "limit", value: String(10)),
            URLQueryItem(name: "query", value: searchText),
            ]
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion([])
            return
        }
                         
        //создаем запрос
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        //Выполняем запрос
        URLSession.shared.dataTask(with: request) { data, response, error in
            //проверяем наличие ошибки
            if let error = error {
                print("Error fetching movies: \(error.localizedDescription)")
                completion([])
                return
            }
            
            // Обработка ошибки 401 (Unauthorized)
            guard let httpResponse = response as? HTTPURLResponse else {
                print ("Invalid response")
                completion([])
                return
            }
            
            if httpResponse.statusCode == 401 {
                print("Ошибка 401: Истек суточный лимит для вашего API-ключа")
                completion([])
                return
            }
            
            //Проверяем статус кода
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response status code")
                completion([])
                return
            }
            
            //Проверяем данные
            guard let data = data else {
                print("No data received")
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(response.docs)
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
                print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
                completion([])
            }
        }.resume()
    }
    
    // MARK: - поиск по жанрам и рейтингу
    
    func fetchMovies(_ currentPage: Int, _ selectedCategory: String?, _ rating: Int?, completion: @escaping ([Movie]) -> Void) {
        
        currentTask?.cancel()
        
        // Создаем базовые компоненты URL
        var urlComponents = URLComponents(string: universalSearchMoviesURLString)
        
        let sortField = (rating != nil) ? "rating.kp" : "votes.kp"
        
        // Создаем массив для query items
        var queryItems = [
            URLQueryItem(name: "limit", value: String(10)),
            URLQueryItem(name: "sortField", value: sortField),
            URLQueryItem(name: "sortType", value: "-1"),
            URLQueryItem(name: "notNullFields", value: "id"),
            URLQueryItem(name: "notNullFields", value: "name"),
            URLQueryItem(name: "notNullFields", value: "poster.url"),
            URLQueryItem(name: "selectFields", value: "id"),
            URLQueryItem(name: "selectFields", value: "name"),
            URLQueryItem(name: "selectFields", value: "description"),
            URLQueryItem(name: "selectFields", value: "rating"),
            URLQueryItem(name: "selectFields", value: "movieLength"),
            URLQueryItem(name: "selectFields", value: "poster"),
            URLQueryItem(name: "selectFields", value: "votes"),
            URLQueryItem(name: "selectFields", value: "genres"),
            
            URLQueryItem(name: "selectFields", value: "year"),
            
            // можно добавить этот запрос, чтобы уменьшить количество выгружаемых данных и ускорить работу сети
//            URLQueryItem(name: "year", value: String(Calendar.current.component(.year, from: Date()))),
            
            URLQueryItem(name: "type", value: "movie")
        ]
        
        // Добавляем параметры жанра
        if let genres = selectedCategory, genres != "Все" {
            if genres == "другие" {
                queryItems.append(URLQueryItem(name: "page", value: String(currentPage)))
                queryItems.append(URLQueryItem(name: "genres.name", value: "!боевик"))
                queryItems.append(URLQueryItem(name: "genres.name", value: "!приключения"))
                queryItems.append(URLQueryItem(name: "genres.name", value: "!детектив"))
                queryItems.append(URLQueryItem(name: "genres.name", value: "!фэнтези"))
            } else {
                queryItems.append(URLQueryItem(name: "page", value: String(currentPage)))
                queryItems.append(URLQueryItem(name: "genres.name", value: genres))
            }
        } else if rating == nil {
            queryItems.append(URLQueryItem(name: "page", value: String(Int.random(in: 1...50))))
        }
        
        // Добавляем параметры рейтинга
        if let ratingNotNil = rating {
            let ratingValue: String
            switch ratingNotNil {
            case 5: ratingValue = "9-10"
            case 4: ratingValue = "7-9"
            case 3: ratingValue = "5-7"
            case 2: ratingValue = "3-5"
            default: ratingValue = "1-3"
            }
            queryItems.append(URLQueryItem(name: "rating.kp", value: ratingValue))
        }
    
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion([])
            return
        }
        // Создаем запрос
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        // Выполняем запрос
        currentTask = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем на наличие ошибки
            if let error = error {
                print("Error fetching movies: \(error.localizedDescription)")
                completion([])
                return
            }
            
            // Обработка ошибки 401 (Unauthorized)
            guard let httpResponse = response as? HTTPURLResponse else {
                print ("Invalid response")
                completion([])
                return
            }
            
            if httpResponse.statusCode == 401 {
                print("Ошибка 401: Истек суточный лимит для вашего API-ключа")
                completion([])
                return
            }
            
            //Проверяем статус кода
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response status code")
                completion([])
                return
            }
            
            // Проверяем данные
            guard let data = data else {
                print("No data received")
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(response.docs)
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
                print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
                completion([])
            }
        }
        currentTask?.resume()
    }
    
    // MARK: - поиск по id
    //(для получения массива актеров и съемочной группы)
    
    func fetchMovieDetail(id: Int, completion: @escaping (MovieDetail?) -> Void) {
        
        //Для поиска по id нельзя установить параметр notNullFields или задать список требуемых полей
        
        // Проверяем валидность URL
        guard let url = URL(string: movieDetailURLString + String(id)) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        // Создаем запрос
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        // Выполняем запрос
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем наличие ошибки
            if let error = error {
                print("Error fetching movies: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Обработка ошибки 401 (Unauthorized)
            guard let httpResponse = response as? HTTPURLResponse else {
                print ("Invalid response")
                completion(nil)
                return
            }
            
            if httpResponse.statusCode == 401 {
                print("Ошибка 401: Истек суточный лимит для вашего API-ключа")
                completion(nil)
                return
            }
            
            //Проверяем статус кода
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response status code")
                completion(nil)
                return
            }
            
            // Проверяем данные
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                completion(movieDetail)
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
                print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
                completion(nil)
            }
        }.resume()
    }
    
    // MARK: - наполнение для карусели главного экрана
    
    func fetchMoviesCaruselHomeScreen(_ currentPage: Int, _ limit: Int, completion: @escaping ([Movie]) -> Void) {
        
        //Создаем базовые компоненты URL
        var urlComponents = URLComponents(string: universalSearchMoviesURLString)!
        
        //Создаем массив для query items
        let queryItems = [
            URLQueryItem(name: "page", value: String(Int.random(in: 1...10))),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "sortField", value: "rating.kp"),
            URLQueryItem(name: "sortType", value: "-1"),
            URLQueryItem(name: "notNullFields", value: "id"),
            URLQueryItem(name: "notNullFields", value: "name"),
            URLQueryItem(name: "notNullFields", value: "poster.url"),
            URLQueryItem(name: "notNullFields", value: "genres.name"),
            URLQueryItem(name: "year", value: String(Calendar.current.component(.year, from: Date()))),
            URLQueryItem(name: "selectFields", value: "id"),
            URLQueryItem(name: "selectFields", value: "name"),
            URLQueryItem(name: "selectFields", value: "description"),
            URLQueryItem(name: "selectFields", value: "rating"),
            URLQueryItem(name: "selectFields", value: "movieLength"),
            URLQueryItem(name: "selectFields", value: "poster"),
            URLQueryItem(name: "selectFields", value: "votes"),
            URLQueryItem(name: "selectFields", value: "genres"),
            URLQueryItem(name: "selectFields", value: "year"),
        ]
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion([])
            return
        }
        
        //Создаем запрос
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        //Выполняем запрос
        URLSession.shared.dataTask(with: request) { data, response, error in
            //Проверяем на наличие ошибки
            if let error = error {
                print("Error fetching movies: \(error.localizedDescription)")
                completion([])
                return
            }
            
            // Обработка ошибки 401 (Unauthorized)
            guard let httpResponse = response as? HTTPURLResponse else {
                print ("Invalid response")
                completion([])
                return
            }
            
            if httpResponse.statusCode == 401 {
                print("Ошибка 401: Истек суточный лимит для вашего API-ключа")
                completion([])
                return
            }
            
            //Проверяем статус кода
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response status code")
                completion([])
                return
            }
            
            //Проверяем данные
            guard let data = data else {
                print("No data received")
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(response.docs)
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
                print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
                completion([])
            }
        }.resume()
    }
    
    // MARK: - наполнение для Box Office главного экрана
    
    func fetchMoviesBoxOfficeHomeScreen(_ currentPage: Int, _ limit: Int, _ genres: String?, completion: @escaping ([Movie]) -> Void) {
        
        //Создаем базовые компоненты URL
        var urlComponents = URLComponents(string: universalSearchMoviesURLString)!
        
        // Создаем массив для query items
        var queryItems = [
            URLQueryItem(name: "page", value: String(Int.random(in: 1...3))),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "sortField", value: "rating.kp"),
            URLQueryItem(name: "sortType", value: "-1"),
            URLQueryItem(name: "type", value: "movie"),
            URLQueryItem(name: "notNullFields", value: "id"),
            URLQueryItem(name: "notNullFields", value: "name"),
            URLQueryItem(name: "notNullFields", value: "poster.url"),
            URLQueryItem(name: "year", value: String(Calendar.current.component(.year, from: Date()))),
            URLQueryItem(name: "selectFields", value: "id"),
            URLQueryItem(name: "selectFields", value: "name"),
            URLQueryItem(name: "selectFields", value: "description"),
            URLQueryItem(name: "selectFields", value: "rating"),
            URLQueryItem(name: "selectFields", value: "movieLength"),
            URLQueryItem(name: "selectFields", value: "poster"),
            URLQueryItem(name: "selectFields", value: "votes"),
            URLQueryItem(name: "selectFields", value: "genres"),
            URLQueryItem(name: "selectFields", value: "year"),
        ]
        
        if let genre = genres {
            if genre == "другие" {
                queryItems.append(URLQueryItem(name: "genres.name", value: "!боевик"))
                queryItems.append(URLQueryItem(name: "genres.name", value: "!приключения"))
                queryItems.append(URLQueryItem(name: "genres.name", value: "!детектив"))
                queryItems.append(URLQueryItem(name: "genres.name", value: "!фэнтези"))
            } else if genre != "Все" {
                queryItems.append(URLQueryItem(name: "genres.name", value: genre))
            }
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion([])
            return
        }
        //Создаем запрос
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        //Выполняем запрос
        URLSession.shared.dataTask(with: request) { data, response, error in
            //Проверяем на наличие ошибки
            if let error = error {
                print("Error fetching movies: \(error.localizedDescription)")
                completion([])
                return
            }
            
            // Обработка ошибки 401 (Unauthorized)
            guard let httpResponse = response as? HTTPURLResponse else {
                print ("Invalid response")
                completion([])
                return
            }
            
            if httpResponse.statusCode == 401 {
                print("Ошибка 401: Истек суточный лимит для вашего API-ключа")
                completion([])
                return
            }
            
            //Проверяем статус кода
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response status code")
                completion([])
                return
            }
            
            //Проверяем данные
            guard let data = data else {
                print("No data received")
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(response.docs)
            } catch let decodingError {
                print("Decoding error: \(decodingError.localizedDescription)")
                print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
            }
        }.resume()
    }
    
    func formatRatingToFiveScale(_ rating: Double?) -> String {
        guard let rating = rating else { return "–" }
        let converted = rating / 2.0
        return String(format: "%.1f", converted)
    }
    
}
