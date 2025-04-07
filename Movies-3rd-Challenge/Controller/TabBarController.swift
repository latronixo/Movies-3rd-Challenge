//
//  TabBarViewController.swift
//  OnlineStore-2nd-Challenge
//
//  Created by Валентин Картошкин on 05.03.2025.
//

import UIKit

//панель вкладок
final class TabBarController: UITabBarController {
    
    private enum TabBarItem: Int {
        case search
        case recentWatch
        case home
        case wishlist
        case settings

        var title: String {
            switch self {
            case .search: return "Search"
            case .recentWatch: return "Recent Watch"
            case .home: return "Home"
            case .wishlist: return "Wishlist"
            case .settings: return "Profile"
            }
        }
        var iconName: String {
            switch self {
            case .search: return "searchIcon"
            case .recentWatch: return "recentWatchIcon"
            case .home: return "homeIcon"
            case .wishlist: return "wishlistIcon"
            case .settings: return "settingsIcon"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabBar()
        self.selectedIndex = 2
    }
    
    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.search, .recentWatch, .home, .wishlist, .settings]
        
        //помещаем в панель вкладок (в свойство viewControllers) массив навигационных контролллеров
        self.viewControllers = dataSource.map{
            switch $0 {
            case .search: return self.wrappedInNavigationController(with: SearchViewController(), title: $0.title)
            case .recentWatch: return self.wrappedInNavigationController(with: TempRecentWatchViewController(), title: $0.title)
            case .home: return self.wrappedInNavigationController(with: MainViewController(), title: $0.title)
            case .wishlist: return self.wrappedInNavigationController(with: FavoritesViewController(), title: $0.title)
            case .settings: return self.wrappedInNavigationController(with: SettingsViewController(), title: $0.title)
            }
        }
        
        self.viewControllers?.enumerated().forEach{
            $1.tabBarItem.title = nil
            // Для Home используем оригинальную иконку
            if dataSource[$0] == .home {
                $1.tabBarItem.image = UIImage(named: dataSource[$0].iconName)?.withRenderingMode(.alwaysOriginal)
                $1.tabBarItem.selectedImage = UIImage(named: dataSource[$0].iconName)?.withRenderingMode(.alwaysOriginal)
            } else {    //для всех остальных иконок - в выбранном состоянии их иконка окрашивается в синий
                $1.tabBarItem.image = UIImage(named: dataSource[$0].iconName)
                $1.tabBarItem.selectedImage = UIImage(named: dataSource[$0].iconName)?.withTintColor(#colorLiteral(red: 0.3195238709, green: 0.3043658733, blue: 0.7124469876, alpha: 1))
            }
            
            $1.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
            $1.tabBarItem.tag = $0
        }
        
        // Настраиваем цвет только для остальных кнопок
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.normal.iconColor = #colorLiteral(red: 0.4862866998, green: 0.4863470197, blue: 0.4821907878, alpha: 1)
        appearance.stackedLayoutAppearance.selected.iconColor = #colorLiteral(red: 0.3195238709, green: 0.3043658733, blue: 0.7124469876, alpha: 1)
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        
        //поддержка темной темы:
        appearance.configureWithOpaqueBackground()
        if #available(iOS 13.0, *) {
            appearance.backgroundColor = .systemBackground
        } else {
            appearance.backgroundColor = .white
        }
        
        
        UITabBar.appearance().standardAppearance = appearance

        
        
    }
    
    //создаем для каждой вкладки свой NavigationController (они будут работать внутри своих вкладок), в качестве корневого вьюконтроллера нужно установить тот, который будет открываться по умолчанию
    private func wrappedInNavigationController(with: UIViewController, title: Any?) -> UINavigationController {
        return UINavigationController(rootViewController:  with)
    }
    
    
}

