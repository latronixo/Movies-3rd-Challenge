import Foundation
import Alamofire

class NetworkService {
    
    private let searchMoviesURLString = "https://api.kinopoisk.dev/v1.4/movie/search"
    private let MovieDetailURLString = "https://api.kinopoisk.dev/v1.4/movie/" //1070216
    private let apiKey = Secrets.apiKey
    
    static let shared = NetworkService()
    
    private init() {}
    
    private let session: URLSession = .shared
    
    //поиск по названию
    func fetchMovies(_ currentPage: Int, _ limit: Int, _ searchText: String?, completion: @escaping ([Movie]) -> Void) {
        
        let parameters: [String: Any] = [
            "page": currentPage,
            "limit": 50,
            "query": searchText
        ]
        
        AF.request(searchMoviesURLString,
                   method: .get,
                   parameters: parameters,
                   headers: ["X-API-KEY": apiKey])
        .responseDecodable(of: MovieResponse.self) { [weak self] response in
            guard self != nil else { return }
            
            switch response.result {
            case .success(let value):
                //print("\(value.docs)")
                completion(value.docs)
            case .failure(let error):
                print("Error fetching movies: \(error)")
                completion([])
            }
        }
    }
    
    //поиск по жанрам и рейтингу
    func fetchMovies(_ currentPage: Int, _ limit: Int, _ genres: String?, _ rating: Int?, completion: @escaping ([Movie]) -> Void) {
        // Создаем базовые компоненты URL
        var urlComponents = URLComponents(string: "https://api.kinopoisk.dev/v1.4/movie")!
        
        // Создаем массив для query items
        var queryItems = [
            URLQueryItem(name: "page", value: String(currentPage)),
            URLQueryItem(name: "limit", value: String(50)),
            URLQueryItem(name: "sortField", value: "rating.kp"),
            URLQueryItem(name: "sortType", value: "-1"),
            URLQueryItem(name: "notNullFields", value: "name"),
            URLQueryItem(name: "notNullFields", value: "id"),
            URLQueryItem(name: "notNullFields", value: "poster.url")
        ]
        
        // Добавляем параметры жанра
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
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion([])
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
                completion([])
                return
            }
            
            // Проверяем статус кода
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
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
        }.resume()
    }
    
    
//    func fetchMovies(_ currentPage: Int, _ limit: Int, _ genres: String?, _ rating: Int?, completion: @escaping ([Movie]) -> Void) {
//        
//        var parameters: [String: Any] = [
//            "page": currentPage,
//            "limit": limit,
//            "sortField": "rating.kp",
//            "sortType": -1,
//            "notNullFields": ["name", "id", "poster.url"],
//        ]
//        
//        //формируем список жанров
//        if let genre = genres {
//            if genre == "другие" {
//                parameters["genres.name"] = ["!боевик", "!приключения", "!детектив", "!фэнтези"]
//            } else if genre != "Все" {
//                parameters["genres.name"] = genre
//            }
//        }
//        
//        // Формируем правильный параметр для рейтинга
//        if let ratingNotNil = rating {
//            switch ratingNotNil{
//            case 5: parameters["rating.kp"] = "9-10"
//            case 4: parameters["rating.kp"] = "7-9"
//            case 3: parameters["rating.kp"] = "5-7"
//            case 2: parameters["rating.kp"] = "3-5"
//            default: parameters["rating.kp"] = "1-3"
//            }
//        }
//        
//        let request = AF.request("https://api.kinopoisk.dev/v1.4/movie",
//                                 method: .get,
//                                 parameters: parameters,
//                                 encoding: URLEncoding.default,
//                                 headers: ["X-API-KEY": apiKey])
//        
//        request.responseDecodable(of: MovieResponse.self) { [weak self] response in
//            guard self != nil else { return }
//            
//            
//            switch response.result {
//            case .success(let value):
//                //print("\(value)")
//                completion(value.docs)
//            case .failure(let error):
//                print("Error fetching movies: \(error)")
//                print("Response data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No data")")
//                completion([])
//            }
//        }
//    }
    
    
    
    //поиск по id
    func fetchMovieDetail(id: Int, completion: @escaping (MovieDetail?) -> Void) {
        
        let parameters: [String: Any] = [:]
        
        let url = MovieDetailURLString + String(id)
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: ["X-API-KEY": apiKey])
        .responseDecodable(of: MovieDetail.self) { [weak self] response in
            guard self != nil else { return }
            
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                print("Error fetching movie detail: \(error)")
                completion(nil)
            }
        }
    }
    
    //наполнение для карусели главного экрана
    func fetchMoviesCaruselHomeScreen(_ currentPage: Int, _ limit: Int, completion: @escaping ([Movie]) -> Void) {
        
        let parameters: [String: Any] = [
            "page": Int.random(in: 1...4),
            "limit": 10,
            "sortField": "rating.kp",
            "sortType": -1,
            "notNullFields": "poster.url",
            "year": "2025"
        ]
        
        let request = AF.request("https://api.kinopoisk.dev/v1.4/movie",
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding.default,
                                 headers: ["X-API-KEY": apiKey])
        
        request.responseDecodable(of: MovieResponse.self) { [weak self] response in
            guard self != nil else { return }
            
            
            switch response.result {
            case .success(let value):
                //print("\(value)")
                completion(value.docs)
            case .failure(let error):
                print("Error fetching movies Carusel: \(error)")
                //print("Response data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No data")")
                completion([])
            }
        }
    }
    
    //наполнение для Box Office главного экрана
    func fetchMoviesBoxOfficeHomeScreen(_ currentPage: Int, _ limit: Int, _ genres: String?, completion: @escaping ([Movie]) -> Void) {
        
        var parameters: [String: Any] = [
            "page": currentPage,
            "limit": limit,
            "sortField": "rating.kp",
            "sortType": -1,
            "notNullFields": ["name", "id"],
            "type": "movie",
            "year": "2025"
        ]
        
        //формируем список жанров
        if let genre = genres {
            if genre == "другие" {
                parameters["genres.name"] = ["!боевик", "!приключения", "!детектив", "!фэнтези"]
            } else if genre != "all" {
                parameters["genres.name"] = genre
            }
        } // если жанр "ALL" то параметр не добавляется = показываются все фильмы без фильтра
        
        let request = AF.request("https://api.kinopoisk.dev/v1.4/movie",
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding.default,
                                 headers: ["X-API-KEY": apiKey])
        
        request.responseDecodable(of: MovieResponse.self) { [weak self] response in
            guard self != nil else { return }
            
            
            switch response.result {
            case .success(let value):
                //print("BOX OFFICE \(value)")
//                print("BOX OFFICE json success")

                completion(value.docs)
                

            case .failure(let error):
                print("Error fetching movies BOX office: \(error)")
                print("Response data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No data")")
                completion([])
            }
            
        }
    }
    
    func formatRatingToFiveScale(_ rating: Double?) -> String {
        guard let rating = rating else { return "–" }
        let converted = rating / 2.0
        return String(format: "%.1f", converted)
    }
    
    
}
