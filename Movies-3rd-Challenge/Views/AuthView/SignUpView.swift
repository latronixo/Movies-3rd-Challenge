//
//  SignUpView.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 08.04.2025.
//

import Foundation
import UIKit

class SignUpView: UIView {
    lazy var firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.font = UIFont(name: "PlusJakartaSans-Medium", size: 14)
        label.textColor = UIColor(named: "discriptionSet")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First Name"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.backgroundColor = UIColor(named: "logColor")
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 24
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        return textField
    }()
    lazy var lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name"
        label.font = UIFont(name: "PlusJakartaSans-Medium", size: 14)
        label.textColor = UIColor(named: "discriptionSet")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last Name"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.backgroundColor = UIColor(named: "logColor")
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 24
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        return textField
    }()
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = UIFont(name: "PlusJakartaSans-Medium", size: 14)
        label.textColor = UIColor(named: "discriptionSet")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.backgroundColor = UIColor(named: "logColor")
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 24
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        return textField
    }()
    lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = UIFont(name: "PlusJakartaSans-Medium", size: 14)
        label.textColor = UIColor(named: "discriptionSet")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.backgroundColor = UIColor(named: "logColor")
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 24
        textField.clipsToBounds = true
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        return textField
    }()
    lazy var eyeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = UIColor(named: "discriptionSet")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm Password"
        label.font = UIFont(name: "PlusJakartaSans-Medium", size: 14)
        label.textColor = UIColor(named: "discriptionSet")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var secondEyeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = UIColor(named: "discriptionSet")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.backgroundColor = UIColor(named: "logColor")
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 24
        textField.clipsToBounds = true
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        return textField
    }()
    lazy var textFieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstNameLabel, firstNameTextField,
                                                       lastNameLabel, lastNameTextField,
                                                       emailLabel, emailTextField,
                                                       passwordLabel, passwordTextField,
                                                       confirmPasswordLabel, confirmPasswordTextField])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    //MARK: buttons
    lazy var signUpButton: UIButton = {
        let signUpButton = UIButton()
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = UIColor(named: "Button")
        signUpButton.layer.cornerRadius = 24
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        return signUpButton
    }()
    lazy var alredyHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var alreadyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [alredyHaveAccountLabel, loginButton])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    init() {
        super.init(frame: .zero)
        setView()
        setConstraint()
    }
    
    func setView(){
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
        confirmPasswordTextField.rightView = secondEyeButton
        confirmPasswordTextField.rightViewMode = .always
        
        addSubview(textFieldsStackView)
        addSubview(signUpButton)
        addSubview(alreadyStackView)
        
    }
    func setConstraint(){
        NSLayoutConstraint.activate([
            alreadyStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            alreadyStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            alreadyStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            
            signUpButton.bottomAnchor.constraint(equalTo: alreadyStackView.topAnchor, constant: -30),
            signUpButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            textFieldsStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            textFieldsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            textFieldsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
            
            
        ])
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
