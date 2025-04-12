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
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if let error = error {
                    print("❌ Не удалось восстановить Google-сессию: \(error.localizedDescription)")
                }

                let auth = UserDefaults.standard.bool(forKey: "isAuth")
                if auth || user != nil {
                    self.window?.rootViewController = TabBarController()
                } else {
                    let navVC = UINavigationController(rootViewController: LoginVC())
                    self.window?.rootViewController = navVC
                }

                self.window?.makeKeyAndVisible()
            }
        
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
//        window?.rootViewController = UINavigationController(rootViewController: auth ? TabBarController() : LoginVC() )
//        window?.makeKeyAndVisible()
        
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        GIDSignIn.sharedInstance.handle(url)
    }

  
}

