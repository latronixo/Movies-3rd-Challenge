//
//  Auth.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 08.04.2025.
//


import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class LoginVC: UIViewController {
    let mainView: LoginView = .init()
    private var remindMe: Bool = true
    
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
        mainView.signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        mainView.googleButton.addTarget(self, action: #selector(signInGoogle), for: .touchUpInside)
        mainView.switchForRemember.addTarget(self, action: #selector(switchValueChanged), for: .touchUpInside)
    }
    //MARK: SIGN_In
    @objc func signInTapped() {
        let email = mainView.emailTextField.text?.lowercased()
        let password = mainView.passwordTextField.text
        
        guard email != nil && email != "", password != nil && password != "" else {
            self.showAlert(title: "Ошибка", message: "Введите данные")
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email!, password: password!) { result, error in
            if let error = error {
                self.cathcAuthError(error: error)
                return
            }
            print("Успешно")
            UserDefaults.standard.set(email, forKey: "email")
            if self.remindMe == true {
                UserDefaults.standard.set(true , forKey: "isAuth")
            } else {
                UserDefaults.standard.set(false , forKey: "isAuth")
            }
            UserDefaults.standard.set("app", forKey: "method")
            DispatchQueue.main.async {
                let vc = OnboardingViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
    }
    @objc func signInGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Ошибка Firebase: \(error.localizedDescription)")
                    return
                }
                UserDefaults.standard.set("google", forKey: "method")
                if self.remindMe == true {
                    UserDefaults.standard.set(true , forKey: "isAuth")
                } else {
                    UserDefaults.standard.set(false , forKey: "isAuth")
                }
                let vc = OnboardingViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func cathcAuthError(error: Error) {
        let errorMessage: String
        if let authError = error as? AuthErrorCode {
            switch authError.code {
            case .userNotFound:
                errorMessage = "Пользователь не найден"
            case .wrongPassword:
                errorMessage = "Неверный пароль"
            case .invalidEmail:
                errorMessage = "Некорректный email"
            default:
                errorMessage = "Ошибка авторизации: \(error.localizedDescription)"
            }
        } else {
            errorMessage = "Неизвестная ошибка"
        }
        
        DispatchQueue.main.async {
            self.showAlert(title: "Ошибка", message: errorMessage)
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
    //MARK: ALERT
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    //MARK: SWITCH
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.remindMe = true
        } else {
            self.remindMe = false
        }
    }
    
}

