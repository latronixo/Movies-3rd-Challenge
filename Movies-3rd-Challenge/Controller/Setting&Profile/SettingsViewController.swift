//
//  SettingsViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Anna Melekhina on 02.04.2025.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - UI Elements

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = userName + " " + lastName
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = login
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var personalInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Personal Info"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  Profile", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setImage(UIImage(systemName: "person"), for: .normal)
        button.tintColor = .label
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileChevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var securityLabel: UILabel = {
        let label = UILabel()
        label.text = "Security"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  Change Password", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setImage(UIImage(systemName: "lock"), for: .normal)
        button.tintColor = .label
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  Forgot Password", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setImage(UIImage(systemName: "exclamationmark.lock"), for: .normal)
        button.tintColor = .label
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var darkModeLabel: UILabel = {
        let label = UILabel()
            label.attributedText = makeLabelWithIcon(
                text: "Dark Mode",
                iconName: "square.and.pencil"
            )
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor.label
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()

    private lazy var darkModeSwitch: UISwitch = {
        let toggle = UISwitch()
        let savedTheme = UserDefaults.standard.string(forKey: "AppTheme") ?? "system"
            toggle.isOn = (savedTheme == "dark")

        toggle.onTintColor = UIColor(named: "mainViolet")
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(darkModeSwitchChanged), for: .valueChanged)
        return toggle
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(UIColor(named: "mainViolet"), for: .normal)
        button.layer.borderColor = UIColor(named: "mainViolet")?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var changeLanguage: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  Choose Language", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setImage(UIImage(systemName: "a.square"), for: .normal)
        button.tintColor = .label
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changeLangTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var userName = "Andy"
    private lazy var lastName = "Lexian"
    private lazy var login = "@" + userName + "999" //непонятно откуда брать, можно первую часть от почты
    private var newPassword: String?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        title = "Settings"
        setupUI()
    }

    // MARK: - Setup UI

    private func setupUI() {
        let elements: [UIView] = [
            profileImageView,
            nameLabel,
            usernameLabel,
            personalInfoLabel,
            profileButton,
            securityLabel,
            changePasswordButton,
            forgotPasswordButton,
            darkModeLabel,
            darkModeSwitch,
            logoutButton,
            profileChevronImageView,
            changeLanguage
        ]
        elements.forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),

            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 24),

            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 24),

            personalInfoLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30),
            personalInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            profileButton.topAnchor.constraint(equalTo: personalInfoLabel.bottomAnchor, constant: 10),
            profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            profileButton.heightAnchor.constraint(equalToConstant: 40),
            
            profileChevronImageView.centerYAnchor.constraint(equalTo: profileButton.centerYAnchor),
            profileChevronImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            profileChevronImageView.widthAnchor.constraint(equalToConstant: 20),
            profileChevronImageView.heightAnchor.constraint(equalToConstant: 20),

            securityLabel.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: 24),
            securityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            changePasswordButton.topAnchor.constraint(equalTo: securityLabel.bottomAnchor, constant: 10),
            changePasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            changePasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 40),

            forgotPasswordButton.topAnchor.constraint(equalTo: changePasswordButton.bottomAnchor, constant: 10),
            forgotPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 40),

            darkModeLabel.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 10),
            darkModeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            darkModeLabel.heightAnchor.constraint(equalToConstant: 40),

            darkModeSwitch.centerYAnchor.constraint(equalTo: darkModeLabel.centerYAnchor),
            darkModeSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            changeLanguage.topAnchor.constraint(equalTo: darkModeLabel.bottomAnchor, constant: 10),
            changeLanguage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            changeLanguage.heightAnchor.constraint(equalToConstant: 40),
            
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func makeLabelWithIcon(text: String, iconName: String) -> NSAttributedString {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        
        let icon = UIImage(systemName: iconName, withConfiguration: configuration)?
            .withTintColor(.label, renderingMode: .alwaysOriginal)
        
        let attachment = NSTextAttachment()
        attachment.image = icon
        attachment.bounds = CGRect(x: 0, y: -2, width: 22, height: 22)

        let attachmentString = NSAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: "  \(text)", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.label
        ])

        let result = NSMutableAttributedString()
        result.append(attachmentString)
        result.append(textString)

        return result
    }
    
    private func setAppTheme(to style: UIUserInterfaceStyle) {
        let themeString: String
           switch style {
           case .dark: themeString = "dark"
           case .light: themeString = "light"
           default: themeString = "system"
           }

           UserDefaults.standard.set(themeString, forKey: "AppTheme")

           if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
               for window in windowScene.windows {
                   window.overrideUserInterfaceStyle = style
               }
           }
    }

    // MARK: - Actions

    @objc private func profileButtonTapped() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: false)
    }

    @objc private func changePasswordButtonTapped() {
        let alert = UIAlertController(title: "Enter new password", message: nil, preferredStyle: .alert)
            
            alert.addTextField { textField in
                textField.placeholder = "New password"
                textField.isSecureTextEntry = true  //не видно, что вводим, зато секьюрно. Можно показывать ввод
                textField.autocapitalizationType = .none
                textField.autocorrectionType = .no
             
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                guard let password = alert.textFields?.first?.text, !password.isEmpty else { return }
                self?.newPassword = password
                
                // сохр в Firebase
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            
            present(alert, animated: true)
    }

    @objc private func forgotPasswordButtonTapped() {
        //запрос в файрбейз
        let alert = UIAlertController(
            title: nil,
            message: "New password was sent to your email",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "Ок", style: .default)
            alert.addAction(okAction)
            
            present(alert, animated: true)
    }

    @objc private func darkModeSwitchChanged() {
        if darkModeSwitch.isOn {
            setAppTheme(to: .dark)
        } else {
            setAppTheme(to: .light)
        }
    }

    @objc private func logoutButtonTapped() {
        //fb
    }
    
    @objc private func changeLangTapped() {
        //локализация
    }
    
}



//
//#Preview { SettingsViewController() }
