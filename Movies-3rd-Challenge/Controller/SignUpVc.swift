//
//  SignUpVc.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 08.04.2025.
//

import Foundation
import UIKit
import  FirebaseAuth

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
        mainView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    @objc func loginButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func signUpButtonTapped() {
        let name = mainView.firstNameTextField.text
        let lastName = mainView.lastNameTextField.text
        let email = mainView.emailTextField.text?.lowercased()
        let password = mainView.passwordTextField.text
        let cofirmPassword = mainView.confirmPasswordTextField.text
        guard name != nil, lastName != nil, email != nil, password != nil, cofirmPassword != nil else {
            self.showAlert(title: "Ошибка", message: "Заполните все поля")
            return
        }
        guard password == cofirmPassword else {
            self.showAlert(title: "Ошибка", message: "Пароли не совпадают")
            return
        }
        FirebaseAuth.Auth.auth().createUser(withEmail: email!, password: password!) { authResult, error in
            if let error = error {
                print("ошибка \(error.localizedDescription)")
                return
            }
            print("успешно")
            let vc = LoginVC()
            self.navigationController?.pushViewController(vc, animated: true)
            UserDefaults.standard.set(name, forKey: "firstName")
            UserDefaults.standard.set(lastName, forKey: "lastName")
            UserDefaults.standard.set(email, forKey: "email")
        }
        
    }
    //MARK: ALERT
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    
}
