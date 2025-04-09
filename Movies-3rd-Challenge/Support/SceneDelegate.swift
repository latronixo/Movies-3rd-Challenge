//
//  SceneDelegate.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 28.03.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let auth = UserDefaults.standard.bool(forKey: "isAuth")
        
        if let theme = UserDefaults.standard.string(forKey: "AppTheme") {
            switch theme {
            case "dark":
                window?.overrideUserInterfaceStyle = .dark
            case "light":
                window?.overrideUserInterfaceStyle = .light
            default:
                window?.overrideUserInterfaceStyle = .unspecified
            }
        }
        window?.rootViewController = UINavigationController(rootViewController: auth ? TabBarController() : LoginVC())
        window?.makeKeyAndVisible()
        
//        let movie = Movie(id: 1, name: "фильм",
//                          description: "Очень Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Show More фильм",
//                          rating: Rating(kp: 9.0),
//                          movieLength: 1,
//                          poster: Poster(url: "ass"),
//                          votes: Votes(kp: 1),
//                          genres: [],
//                          year: 2024)
//        let detail = MovieDetail(persons: [])
//               let movieDetailVC = TempMovieDetailViewController(movie: movie, detail: detail)
//               let navigationController = UINavigationController(rootViewController: movieDetailVC)
//               
//               // Настройка UIWindow
//               let window = UIWindow(windowScene: windowScene)
//               window.rootViewController = navigationController
//               self.window = window
//               window.makeKeyAndVisible()
    }
//    func sceneDidBecomeActive(_ scene: UIScene) {
//        if let theme = UserDefaults.standard.string(forKey: "AppTheme") {
//                switch theme {
//                case "dark":
//                    window?.overrideUserInterfaceStyle = .dark
//                case "light":
//                    window?.overrideUserInterfaceStyle = .light
//                default:
//                    window?.overrideUserInterfaceStyle = .unspecified  
//                }
//            }
//        }
  
}

