//
//  ForgetPassVC.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 08.04.2025.
//

import Foundation
import UIKit

class ForgetPassVC: UIViewController {
    let mainView: ForgetPass = .init()
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .systemBackground
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(
            string: "Forgot your password?",
            attributes: [
                .font: UIFont(name: "PlusJakartaSans-Bold", size: 26) ?? .systemFont(ofSize: 26)])
        self.navigationItem.titleView = titleLabel
    }
    
    
}
