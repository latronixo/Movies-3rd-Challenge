//
//  SignUpVc.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 08.04.2025.
//

import Foundation
import UIKit
import  FirebaseAuth
import FirebaseFirestore

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
        mainView.eyeButton.addTarget(self, action: #selector(showPass), for: .touchUpInside)
        mainView.secondEyeButton.addTarget(self, action: #selector(showPass), for: .touchUpInside)
    
    updateLocalizedText()
}

override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            addObserverForLocalization()
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            removeObserverForLocalization()
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
        guard let name = name, !name.isEmpty,
              let lastName = lastName, !lastName.isEmpty,
              let email = email, !email.isEmpty,
              let password = password, !password.isEmpty,
              let confirmPassword = cofirmPassword, !confirmPassword.isEmpty else {
            self.showAlert(title: "Ошибка", message: "Заполните все поля")
            return
        }
        
        // Проверка валидности email
        if let emailError = validateEmail(email) {
            self.showAlert(title: "Ошибка", message: emailError)
            return
        }
        
        guard password == cofirmPassword else {
            self.showAlert(title: "Ошибка", message: "Пароли не совпадают")
            return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.catchAuthError(error: error)
                return
            }
            guard let user = authResult?.user else {
                self.showAlert(title: "Ошибка", message: "Пользователь не создан")
                return
            }
            self.saveUserToFireStore(userId: user.uid, firstName: name, lastName: lastName, email: email)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func validateEmail(_ email: String) -> String? {
        // Проверка на запрещенные символы
        let forbiddenCharacters = ["!", "#", "$", "%", "&", "~", "=", ",", "'"]
        for char in forbiddenCharacters {
            if email.contains(char) {
                return "Email не может содержать символ: \(char)"
            }
        }
        
        // Проверка на пробелы и табуляцию
        if email.contains(" ") || email.contains("\t") {
            return "Email не может содержать пробелы или табуляцию"
        }
        
        // Проверка на несколько точек подряд
        if email.contains("..") {
            return "Email не может содержать несколько точек подряд"
        }
        
        // Проверка на кириллицу
        let cyrillicRegex = ".*[А-Яа-я].*"
        if email.range(of: cyrillicRegex, options: .regularExpression) != nil {
            return "Email не может содержать кириллицу"
        }
        
        // Базовая проверка формата email
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            return "Некорректный формат email"
        }
        
        return nil
    }
    
    private func catchAuthError(error: Error) {
        let errorMessage: String
        if let authError = error as? AuthErrorCode {
            switch authError.code {
            case .emailAlreadyInUse:
                errorMessage = "Этот email уже используется"
            case .invalidEmail:
                errorMessage = "Некорректный email"
            case .weakPassword:
                errorMessage = "Слишком слабый пароль. Минимум 6 символов"
            case .networkError:
                errorMessage = "Ошибка сети. Проверьте подключение к интернету"
            default:
                errorMessage = "Ошибка регистрации: \(error.localizedDescription)"
            }
        } else if let nsError = error as NSError? {
            switch nsError.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                errorMessage = "Этот email уже используется"
            case AuthErrorCode.invalidEmail.rawValue:
                errorMessage = "Некорректный email"
            case AuthErrorCode.weakPassword.rawValue:
                errorMessage = "Слишком слабый пароль. Минимум 6 символов"
            case AuthErrorCode.networkError.rawValue:
                errorMessage = "Ошибка сети. Проверьте подключение к интернету"
            default:
                errorMessage = "Ошибка регистрации: \(error.localizedDescription)"
            }
        } else {
            errorMessage = "Неизвестная ошибка: \(error.localizedDescription)"
        }
        
        DispatchQueue.main.async {
            self.showAlert(title: "Ошибка", message: errorMessage)
        }
    }
    
    //MARK: FireStore
    func saveUserToFireStore(userId: String, firstName: String, lastName: String, email: String) {
        let dataBase = Firestore.firestore()
        dataBase.collection(UsersFireSore.collectionName.rawValue).document(userId).setData ([
            UsersFireSore.id.rawValue: userId,
            UsersFireSore.firstName.rawValue: firstName,
            UsersFireSore.lastName.rawValue: lastName,
            UsersFireSore.email.rawValue: email,
            UsersFireSore.dateOfBirth.rawValue: "Еще не задано",
            UsersFireSore.male.rawValue: "Еще не задано",
            UsersFireSore.location.rawValue: "Еще не задано"
        ]) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Ошибка", message: "Ошибка сохранения данных: \(error.localizedDescription)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
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
    
    //MARK: EyeButtons
    @objc func showPass(selector: UIButton) {
        var textField: UITextField?
        if selector == self.mainView.eyeButton as UIButton {
            textField = self.mainView.passwordTextField
        } else {
            textField = self.mainView.confirmPasswordTextField
        }
        guard let field = textField else { return }
        field.isSecureTextEntry.toggle()
        let imageName = field.isSecureTextEntry ? "eye.slash" : "eye"
        selector.setImage(UIImage(systemName: imageName), for: .normal)
    }
}

extension SignUpVc {
    private func addObserverForLocalization() {
        NotificationCenter.default.addObserver(forName: LanguageManager.languageDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateLocalizedText()
        }
    }
    
    private func removeObserverForLocalization() {
        NotificationCenter.default.removeObserver(self, name: LanguageManager.languageDidChangeNotification, object: nil)
    }
    
    func updateLocalizedText() {
        mainView.firstNameLabel.text = "First Name".localized()
        mainView.firstNameTextField.placeholder = "First Name".localized()

        mainView.lastNameLabel.text = "Last Name".localized()
        mainView.lastNameTextField.placeholder = "Last Name".localized()

        mainView.emailLabel.text = "Email".localized()
        mainView.emailTextField.placeholder = "Email".localized()

        mainView.passwordLabel.text = "Password".localized()
        mainView.passwordTextField.placeholder = "Password".localized()

        mainView.confirmPasswordLabel.text = "Confirm Password".localized()
        mainView.confirmPasswordTextField.placeholder = "Confirm Password".localized()

        mainView.signUpButton.setTitle("Sign Up".localized(), for: .normal)

        mainView.alredyHaveAccountLabel.text = "Already have an account?".localized()
        mainView.loginButton.setTitle("Login".localized(), for: .normal)
        
        if let label = navigationItem.titleView as? UILabel {
                label.text = "Sign Up".localized()
            }
    }

}
