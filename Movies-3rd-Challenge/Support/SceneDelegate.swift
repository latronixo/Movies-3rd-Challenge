//
//  SceneDelegate.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 28.03.2025.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let auth = UserDefaults.standard.bool(forKey: "isAuth")
//        let auth = true
        
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
        window?.rootViewController = UINavigationController(rootViewController: auth ? TabBarController() : LoginVC() )
        window?.makeKeyAndVisible()
        
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        GIDSignIn.sharedInstance.handle(url)
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

