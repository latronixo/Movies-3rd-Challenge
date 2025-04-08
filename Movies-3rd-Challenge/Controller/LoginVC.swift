//
//  Auth.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 08.04.2025.
//


import UIKit
import FirebaseAuth
class LoginVC: UIViewController {
    let mainView: LoginView = .init()
    private var saveIsOn: Bool = false
    private var showAlert: Bool = false
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(
            string: "Авторизация",
            attributes: [
                .font: UIFont(name: "PlusJakartaSans-Bold", size: 26) ?? .systemFont(ofSize: 26)])
        self.navigationItem.titleView = titleLabel
        mainView.backgroundColor = .systemBackground
        mainView.signupButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        mainView.forgetPasswordButton.addTarget(self, action: #selector(forgetPasswordTapped), for: .touchUpInside)
    }
    
    @objc func signInTapped() {
        var email = mainView.emailTextField.text
        var password = mainView.passwordTextField.text
        
        guard email != nil, password != nil else {
            showAlert = true
            return
        }
        
        
    }
    
    //MARK: NAVIGATION
    @objc func signUpTapped() {
        let nextVC = SignUpVc()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func forgetPasswordTapped() {
        let vc = ForgetPassVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
//https://github.com/google/GoogleSignIn-iOS google
