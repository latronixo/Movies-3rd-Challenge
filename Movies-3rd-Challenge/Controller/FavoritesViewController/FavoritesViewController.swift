//
//  FavoritesViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Elina Kanzafarova on 01.04.2025.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - UI
    
    private let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func setViews() {
        view.addSubview(tableView)
    }

}
