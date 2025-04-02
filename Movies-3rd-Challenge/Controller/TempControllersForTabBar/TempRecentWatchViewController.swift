//
//  TempRecentWatchViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 31.03.2025.
//

import UIKit

class TempRecentWatchViewController: UIViewController {

    private lazy var labelLogin: UILabel = {
        let element = UILabel()
        element.text = "Recent Watch"
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(labelLogin)
        
        NSLayoutConstraint.activate([
            labelLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelLogin.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
