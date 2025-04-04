import Foundation
import Alamofire

class NetworkService {
    
    private let searchMoviesURLString = "https://api.kinopoisk.dev/v1.4/movie/search"
    private let MovieDetailURLString = "https://api.kinopoisk.dev/v1.4/movie/" //1070216
    private let apiKey = Secrets.apiKey

    static let shared = NetworkService()
    
    private init() {}
    
    private let session: URLSession = .shared
    
    //поиск по назнванию
    func fetchMovies(_ currentPage: Int, _ limit: Int, _ searchText: String?, completion: @escaping ([Movie]) -> Void) {
        
        let parameters: [String: Any] = [
            "page": currentPage,
            "limit": limit,
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
    func fetchMovies(_ currentPage: Int, _ limit: Int, _ genres: String?, _ rating: String?, completion: @escaping ([Movie]) -> Void) {
        
        var parameters: [String: Any] = [
            "page": currentPage,
            "limit": limit,
            "sortField": "rating.kp",
            "sortType": -1,
            "notNullFields": "name",
         ]
        
        //формируем список жанров
        if let genre = genres {
            if genre == "другие" {
                parameters["genres.name"] = ["!боевик", "!приключения", "!детектив", "!фэнтези"]
            } else {
                parameters["genres.name"] = genre
            }
        } else {
            parameters["genres.name"] = [""]
        }

        
        // Формируем правильный параметр для рейтинга
        if let ratingNotNil = rating {
            parameters["rating.kp"] = ratingNotNil
        }
        
        let request = AF.request("https://api.kinopoisk.dev/v1.4/movie",
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: ["X-API-KEY": apiKey])
        
        request.responseDecodable(of: MovieResponse.self) { [weak self] response in
                guard self != nil else { return }
                
                
                switch response.result {
                case .success(let value):
                    print("\(value)")
                    completion(value.docs)
                case .failure(let error):
                    print("Error fetching movies: \(error)")
                    print("Response data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No data")")
                    completion([])
                }
            }
    }
    
    
    //поиск по id
    func fetchMovieDetail(id: Int, completion: @escaping (MoviewDetailResponse?) -> Void) {
        
        let parameters: [String: Any] = [:]
        
        let url = MovieDetailURLString + String(id)
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: ["X-API-KEY": apiKey])
            .responseDecodable(of: MoviewDetailResponse.self) { [weak self] response in
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
    
}
