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
        
        if let isDarkMode = UserDefaults.standard.value(forKey: "isDarkMode") as? Bool {
            if #available(iOS 13.0, *) {
                UIWindow.appearance().overrideUserInterfaceStyle = isDarkMode ? .dark : .light
            }
        }
        
        let auth = true
        
        window?.rootViewController = UINavigationController(rootViewController: auth ? TabBarController() : TempLoginViewController())
        
        window?.makeKeyAndVisible()
    }

  
}

