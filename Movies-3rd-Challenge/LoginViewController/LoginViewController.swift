//
//  LoginView.swift
//  Movies-3rd-Challenge
//
//  Created by Александр Слыховский on 01.04.2025.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Colors
    private let backgroundColor: UIColor = {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0) // #1C1C1F
            default:
                return .white
            }
        }
    }()
    
    private let textFieldBackgroundColor: UIColor = {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.0) // #2C2C2E
            default:
                return UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
            }
        }
    }()
    
    private let buttonBackgroundColor: UIColor = {
        return UIColor(red: 0.4, green: 0.4, blue: 0.8, alpha: 1.0)
    }()
    
    private let textColor: UIColor = {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .white
            default:
                return .black
            }
        }
    }()
    
    private let secondaryTextColor: UIColor = {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .lightGray
            default:
                return .darkGray
            }
        }
    }()
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .systemFont(ofSize: 14)
        label.textColor = secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = textFieldBackgroundColor
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.textColor = textColor
        configureTextField(textField, placeholder: "Enter your email address")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = .systemFont(ofSize: 14)
        label.textColor = secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = textFieldBackgroundColor
        textField.layer.cornerRadius = 12
        textField.isSecureTextEntry = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.rightView = passwordVisibilityButton
        textField.rightViewMode = .always
        textField.textColor = textColor
        configureTextField(textField, placeholder: "Enter your password")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordVisibilityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = secondaryTextColor
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()
    
    private lazy var rememberMeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var rememberMeSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = buttonBackgroundColor
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private lazy var rememberMeLabel: UILabel = {
        let label = UILabel()
        label.text = "Remember Me"
        label.font = .systemFont(ofSize: 14)
        label.textColor = secondaryTextColor
        return label
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.tintColor = buttonBackgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = buttonBackgroundColor
        button.layer.cornerRadius = 25
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var separatorLabel: UILabel = {
        let label = UILabel()
        label.text = "Or continue with"
        label.font = .systemFont(ofSize: 14)
        label.textColor = secondaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue with Google", for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let googleImage = UIImage(named: "google_icon")?.withRenderingMode(.alwaysOriginal)
        button.setImage(googleImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        
        return button
    }()
    
    private lazy var signUpStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var noAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.font = .systemFont(ofSize: 14)
        label.textColor = secondaryTextColor
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.tintColor = buttonBackgroundColor
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = backgroundColor
        
        view.addSubview(titleLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        
        rememberMeStack.addArrangedSubview(rememberMeSwitch)
        rememberMeStack.addArrangedSubview(rememberMeLabel)
        view.addSubview(rememberMeStack)
        
        view.addSubview(forgotPasswordButton)
        view.addSubview(signInButton)
        view.addSubview(separatorLabel)
        view.addSubview(googleButton)
        
        signUpStack.addArrangedSubview(noAccountLabel)
        signUpStack.addArrangedSubview(signUpButton)
        view.addSubview(signUpStack)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            rememberMeStack.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            rememberMeStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            forgotPasswordButton.centerYAnchor.constraint(equalTo: rememberMeStack.centerYAnchor),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            signInButton.topAnchor.constraint(equalTo: rememberMeStack.bottomAnchor, constant: 32),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            
            separatorLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 24),
            separatorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            googleButton.topAnchor.constraint(equalTo: separatorLabel.bottomAnchor, constant: 24),
            googleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            googleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            googleButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            signUpStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        setupActions()
    }
    
    private func configureTextField(_ textField: UITextField, placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor { traitCollection in
                    switch traitCollection.userInterfaceStyle {
                    case .dark:
                        return UIColor.lightGray
                    default:
                        return UIColor.gray
                    }
                }
            ]
        )
    }
    
    // MARK: - Actions
    private func setupActions() {
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleSignInTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        passwordVisibilityButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func signInTapped() {
        // Implement sign in logic
    }
    
    @objc private func forgotPasswordTapped() {
        // Navigate to forgot password screen
    }
    
    @objc private func googleSignInTapped() {
        // Implement Google sign in
    }
    
    @objc private func signUpTapped() {
        // Navigate to sign up screen
    }
    
    // MARK: - Theme Support
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            view.backgroundColor = backgroundColor
            emailTextField.backgroundColor = textFieldBackgroundColor
            passwordTextField.backgroundColor = textFieldBackgroundColor
            
            // Обновляем цвет границы кнопки Google
            googleButton.layer.borderColor = UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor.darkGray
                default:
                    return UIColor.lightGray
                }
            }.cgColor
        }
    }
}
