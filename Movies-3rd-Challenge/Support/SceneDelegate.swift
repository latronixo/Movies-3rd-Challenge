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
        
        checkAuthState()
        
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
    
    private func checkAuthState() {
        
        guard UserDefaults.standard.bool(forKey: "isAuth") else {
            showLoginScreen()
            return
        }
        
        if Auth.auth().currentUser != nil {
                  self.setMainScreen()
                  return
        }
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if let error = error {
                print("❌ Не удалось восстановить Google-сессию: \(error.localizedDescription)")
            }
            
            if user != nil {
                self?.setMainScreen()
            } else {
                self?.showLoginScreen()
            }
            self?.window?.makeKeyAndVisible()
        }
    }
    
    private func setMainScreen() {
           DispatchQueue.main.async {
               self.window?.rootViewController = TabBarController()
               self.window?.makeKeyAndVisible()
           }
       }
    
    private func showLoginScreen() {
        let navVC = UINavigationController(rootViewController: LoginVC())
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
    
        
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        GIDSignIn.sharedInstance.handle(url)
    }
}
