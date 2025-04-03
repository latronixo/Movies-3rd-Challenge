import Foundation
import Alamofire

class NetworkService {
    
    private let searchMoviesURLString = "https://api.kinopoisk.dev/v1.4/movie/search"
    private let MovieDetailURLString = "https://api.kinopoisk.dev/v1.4/movie/" //1070216
    private let apiKey = Secrets.apiKey

    static let shared = NetworkService()
    
    private init() {}
    
    private let session: URLSession = .shared
    
    func fetchMovies(currentPage: Int, limit: Int, searchText: String?, genres: String?, completion: @escaping ([Movie]) -> Void) {
        
        let parameters: [String: Any] = [
            "currentPage": currentPage,
            "limit": limit,
            "query": searchText ?? "Павел"//,
            //"genres": genres ?? ""
        ]
        
        AF.request(searchMoviesURLString,
                   method: .get,
                   parameters: parameters,
                   headers: ["X-API-KEY": apiKey])
            .responseDecodable(of: MovieResponse.self) { [weak self] response in
                guard self != nil else { return }
                
                switch response.result {
                case .success(let value):
                    completion(value.docs)
                case .failure(let error):
                    print("Error fetching movies: \(error)")
                    completion([])
                }
            }
    }
    
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
