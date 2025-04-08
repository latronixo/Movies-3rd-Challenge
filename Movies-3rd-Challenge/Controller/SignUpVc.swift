//
//  SignUpVc.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 08.04.2025.
//

import Foundation
import UIKit

class SignUpVc: UIViewController {
    let mainView: SignUpView = .init()
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(
            string: "Sign Up",
            attributes: [
                .font: UIFont(name: "PlusJakartaSans-Bold", size: 26) ?? .systemFont(ofSize: 26)])
        self.navigationItem.titleView = titleLabel
        mainView.backgroundColor = .systemBackground
        mainView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
    }
    @objc func loginButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
}
