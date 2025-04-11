//
//  AuthView.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 08.04.2025.
//

import Foundation
import UIKit

class LoginView: UIView {
    
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
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(named: "logColor")
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 24
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    lazy var eyeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = UIColor(named: "discriptionSet")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var stackForTextFields: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField, passwordLabel, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    //MARK: SWitch
    lazy var switchForRemember: UISwitch = {
        let switchForRemember = UISwitch()
        switchForRemember.isOn = true
        switchForRemember.transform = CGAffineTransform(scaleX: 0.8, y: 0.7)
        switchForRemember.onTintColor = UIColor(named: "switch")
        switchForRemember.translatesAutoresizingMaskIntoConstraints = false
        return switchForRemember
    }()
    lazy var switchLabel: UILabel = {
        let switchLabel = UILabel()
        switchLabel.text = "Remember me"
        switchLabel.font = UIFont(name: "PlusJakartaSans-Medium", size: 14)
        switchLabel.textColor = UIColor(named: "discriptionSet")
        switchLabel.translatesAutoresizingMaskIntoConstraints = false
        return switchLabel
    }()
    lazy var forgetPasswordButton: UIButton = {
        let forgetPasswordButton = UIButton()
        forgetPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgetPasswordButton.setTitleColor(UIColor(named: "switch"), for: .normal)
        forgetPasswordButton.titleLabel?.font = UIFont(name: "PlusJakartaSans-Medium", size: 14)
        forgetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        return forgetPasswordButton
    }()
    
    lazy var switchStackView: UIStackView = {
        let switchStackView = UIStackView(arrangedSubviews: [switchForRemember, switchLabel, forgetPasswordButton])
        switchStackView.axis = .horizontal
        switchStackView.alignment = .fill
        switchStackView.spacing = 8
        switchStackView.translatesAutoresizingMaskIntoConstraints = false
        return switchStackView
    }()
    //MARK: Buttons
    lazy var signInButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Sign In", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(named: "Button")
        loginButton.layer.cornerRadius = 24
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    lazy var leftDivideLine: UIImageView = {
        let divideLine = UIImageView()
        divideLine.image = UIImage(named: "line")
        divideLine.backgroundColor = UIColor(named: "divideLine")
        divideLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divideLine.translatesAutoresizingMaskIntoConstraints = false
        return divideLine
    }()
    lazy var textDevideLine: UILabel = {
        let txt = UILabel()
        txt.text = "Or continue with"
        txt.textColor = UIColor(named: "divideLine")
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    lazy var rightDivideLine: UIImageView = {
        let divideLine = UIImageView()
        divideLine.image = UIImage(named: "line")
        divideLine.backgroundColor = UIColor(named: "divideLine")
        divideLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divideLine.translatesAutoresizingMaskIntoConstraints = false
        return divideLine
    }()
    lazy var divideLineStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [leftDivideLine, textDevideLine, rightDivideLine])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    lazy var googleButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Continue with Google"
        configuration.image = UIImage(named: "google")
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "divideLine")?.cgColor
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var stackForButtons: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [signInButton, divideLineStackView, googleButton])
        stack.axis = .vertical
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    //MARK: SIGN UP
    lazy var signupLabel: UILabel = {
        let signupLabel = UILabel()
        signupLabel.text = "Don't have an account?"
        signupLabel.font = UIFont(name: "PlusJakartaSans-Medium", size: 14)
        signupLabel.translatesAutoresizingMaskIntoConstraints = false
        return signupLabel
    }()
    lazy var signupButton: UIButton = {
        let signupButton = UIButton()
        signupButton.setTitle("Sign up", for: .normal)
        signupButton.setTitleColor(UIColor(named: "Button"), for: .normal)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        return signupButton
    }()
    lazy var stackForSignup: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [signupLabel, signupButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        setView()
        setConstraint()
    }
    
    func setView(){
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always

        addSubview(stackForTextFields)
        addSubview(switchStackView)
        addSubview(stackForButtons)
        addSubview(stackForSignup)
        leftDivideLine.widthAnchor.constraint(equalTo: rightDivideLine.widthAnchor).isActive = true
        
    }
    func setConstraint(){
        NSLayoutConstraint.activate([
            stackForTextFields.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            stackForTextFields.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            stackForTextFields.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            stackForTextFields.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 52),
            emailTextField.leftAnchor.constraint(equalTo: stackForTextFields.leftAnchor),
            emailTextField.rightAnchor.constraint(equalTo: stackForTextFields.rightAnchor),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 52),
            passwordTextField.leftAnchor.constraint(equalTo: stackForTextFields.leftAnchor),
            passwordTextField.rightAnchor.constraint(equalTo: stackForTextFields.rightAnchor),
            
            switchStackView.topAnchor.constraint(equalTo: stackForTextFields.bottomAnchor, constant: 20),
            switchStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            switchStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            switchStackView.heightAnchor.constraint(equalToConstant: 19),
            
            
            
            stackForButtons.bottomAnchor.constraint(equalTo: stackForSignup.topAnchor, constant: -50),
            stackForButtons.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            stackForButtons.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 56),
            googleButton.heightAnchor.constraint(equalToConstant: 56),
            divideLineStackView.heightAnchor.constraint(equalToConstant: 22),
            textDevideLine.heightAnchor.constraint(equalTo: divideLineStackView.heightAnchor),
            textDevideLine.centerYAnchor.constraint(equalTo: divideLineStackView.centerYAnchor),
            
            stackForSignup.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackForSignup.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackForSignup.heightAnchor.constraint(equalToConstant: 25),
            ])
            
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
