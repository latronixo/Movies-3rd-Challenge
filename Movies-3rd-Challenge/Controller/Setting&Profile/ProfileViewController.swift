//
//  ProfileViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Anna Melekhina on 02.04.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FirebaseCore

class ProfileViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: selectedAvatarName))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var editAvatarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "mainViolet")
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editAvatarTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var firstNameLabel = makeLabel(text: "First Name")
    private lazy var lastNameLabel = makeLabel(text: "Last Name")
    private lazy var emailLabel = makeLabel(text: "E-mail")
    private lazy var dobLabel = makeLabel(text: "Date of Birth")
    private lazy var genderLabel = makeLabel(text: "Gender")
    private lazy var locationLabel = makeLabel(text: "Location/notes")
    
    private lazy var firstNameTextField = makeTextField(placeholder: "First Name")
    private lazy var lastNameTextField = makeTextField(placeholder: "Last Name")
    private lazy var emailTextField = makeTextField(placeholder: "E-mail")
    private lazy var locationTextView = makeTextField(placeholder: "Location/notes")

    
    private lazy var dobView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(named: "mainViolet")?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dobValueLabel)
        view.addSubview(dobButton)
        return view
    }()
    
    private lazy var dobValueLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dobButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.tintColor = UIColor(named: "mainViolet")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openDatePicker), for: .touchUpInside)
        return button
    }()
    
    private lazy var maleButton = makeGenderButton(title: "Male", isSelected: true)
    private lazy var femaleButton = makeGenderButton(title: "Female", isSelected: false)
    
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Changes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "mainViolet")
        button.layer.cornerRadius = 24
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveChangesButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.backgroundColor = .systemBackground
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.tintColor = UIColor(named: "mainViolet")
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()

    private lazy var datePickerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.addSubview(datePicker)
        return view
    }()
    
    private var firstName = ""
    private var lastName = ""
    private var email = ""
    private var notes = ""
    private var birthDate = ""
    private var newPassword = ""
    private var selectedAvatarName: String = "avatar1"
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profile"
        setupUI()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        locationTextView.delegate = self
        
        updateLocalizedText()
        loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserverForLocalization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverForLocalization()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        let scrollView = UIScrollView()
        let contentView = UIView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [avatarImageView, editAvatarButton,
         firstNameLabel, firstNameTextField,
         lastNameLabel, lastNameTextField,
         emailLabel, emailTextField,
         dobLabel, dobView,
         genderLabel, maleButton, femaleButton,
         locationLabel, locationTextView,
         saveButton, datePickerContainer].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            
            editAvatarButton.widthAnchor.constraint(equalToConstant: 28),
            editAvatarButton.heightAnchor.constraint(equalToConstant: 28),
            editAvatarButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4),
            editAvatarButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 4),
            
            firstNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 30),
            firstNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 4),
            firstNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            firstNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
            lastNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 4),
            lastNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            lastNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            emailLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 16),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            dobLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            dobLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            dobView.topAnchor.constraint(equalTo: dobLabel.bottomAnchor, constant: 4),
            dobView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            dobView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            dobView.heightAnchor.constraint(equalToConstant: 44),
            
            dobValueLabel.leadingAnchor.constraint(equalTo: dobView.leadingAnchor, constant: 12),
            dobValueLabel.centerYAnchor.constraint(equalTo: dobView.centerYAnchor),
            dobButton.trailingAnchor.constraint(equalTo: dobView.trailingAnchor, constant: -12),
            dobButton.centerYAnchor.constraint(equalTo: dobView.centerYAnchor),
            
            genderLabel.topAnchor.constraint(equalTo: dobView.bottomAnchor, constant: 16),
            genderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            maleButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 8),
            maleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            maleButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            maleButton.heightAnchor.constraint(equalToConstant: 36),
            
            femaleButton.centerYAnchor.constraint(equalTo: maleButton.centerYAnchor),
            femaleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            femaleButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            femaleButton.heightAnchor.constraint(equalToConstant: 36),
            
            locationLabel.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            locationTextView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            locationTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            locationTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            locationTextView.heightAnchor.constraint(equalToConstant: 100),
            
            saveButton.topAnchor.constraint(equalTo: locationTextView.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            datePickerContainer.topAnchor.constraint(equalTo: dobView.bottomAnchor, constant: 12),
            datePickerContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            datePickerContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),

            datePicker.topAnchor.constraint(equalTo: datePickerContainer.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainer.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainer.trailingAnchor)
        ])
        
        emailTextField.textContentType = .emailAddress
        emailTextField.keyboardType = .emailAddress
    }
    
    // MARK: - ui methods
    
    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeTextField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder.localized()
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.textColor = .label
        tf.layer.borderColor = UIColor(named: "mainViolet")?.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 18
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.autocapitalizationType = .none
        tf.setLeftPaddingPoints(12)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
    
    private func makeGenderButton(title: String, isSelected: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(isSelected ? .white : .label, for: .normal)
        button.backgroundColor = isSelected ? UIColor(named: "mainViolet") : .clear
        button.layer.borderColor = UIColor(named: "mainViolet")?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(genderButtonTapped), for: .touchUpInside)
        return button
    }
    
    // MARK: - Actions
    
    @objc private func editAvatarTapped() {
        let alertVC = AvatarViewController()
            
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            
            alertVC.onTakePhoto = { 
                print("камера")
            }

        alertVC.onChoosePhoto = {[weak self] in
            alertVC.onAvatarSelected = { selectedAvatar in
                self?.avatarImageView.image = UIImage(named: selectedAvatar)
                self?.selectedAvatarName = selectedAvatar
            }
        }

            alertVC.onDeletePhoto = { [weak self] in
                self?.avatarImageView.image = UIImage(named: "gradientPoster")
                
            }

            present(alertVC, animated: true)
    }
    
    @objc private func genderButtonTapped(_ sender: UIButton) {
        [maleButton, femaleButton].forEach {
            $0.backgroundColor = .clear
            $0.setTitleColor(.label, for: .normal)
        }
        sender.backgroundColor = UIColor(named: "mainViolet")
        sender.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - Date Picker

    @objc private func openDatePicker() {
        datePickerContainer.isHidden.toggle()
    }

    @objc private func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "en_US")

        let formatted = formatter.string(from: datePicker.date)
        dobValueLabel.text = formatted
    }
    
    //проверка емейла
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
        return email.firstMatch(of: emailRegex) != nil
    }
    
    private func showFormatErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Invalid format. Data is not saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showPassErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Password should be no less than 6 symbols", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showSucessSaveAlert() {
        let alert = UIAlertController(title: "Saved successfully!", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func saveChangesButtonAction(_ button: UIButton) {
        print(Auth.auth().currentUser?.uid ?? "no user data")
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
            
            let updatedUser = User(
                id: currentUserId,
                firstName: firstNameTextField.text ?? "",
                lastName: lastNameTextField.text ?? "",
                email: emailTextField.text ?? "",
                male: maleButton.isSelected ? "Male" : "Female",
                dateOfBirth: dobValueLabel.text ?? "",
                location: locationTextView.text ?? "",
                didSeeOnboarding: true,
                avatarName: selectedAvatarName
            )
            
            UserInfo.shared.updateDataUser(user: updatedUser) { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        self?.showSucessSaveAlert()
                    } else {
                        self?.showFormatErrorAlert()
                    }
                }
            }
    }
    
    private func loadUserData() {
        UserInfo.shared.getUser { [weak self] user in
            guard let self = self, let user = user else { return }
            DispatchQueue.main.async {
                self.firstNameTextField.text = user.firstName
                self.lastNameTextField.text = user.lastName
                self.emailTextField.text = user.email
                self.locationTextView.text = user.location
                self.dobValueLabel.text = user.dateOfBirth
                
                if user.male.lowercased() == "female" {
                    self.genderButtonTapped(self.femaleButton)
                } else {
                    self.genderButtonTapped(self.maleButton)
                }
                self.avatarImageView.image = UIImage(named: user.avatarName)
            }
        }
    }

}

// MARK: - UITextField Padding Helper

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}

//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let selectedImage = info[.editedImage] as? UIImage else {
//            dismiss(animated: true, completion: nil)
//            return
//        }
//        
//        avatarImageView.image = selectedImage
//        
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
}

extension ProfileViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextField:
            firstName = textField.text ?? ""
        case lastNameTextField:
            lastName = textField.text ?? ""
        case emailTextField:
            if let text = textField.text, isValidEmail(text) {
                email = text
            } else {
                showFormatErrorAlert()
                textField.text = ""
            }
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstNameTextField || textField == lastNameTextField {
            var allowedCharacterSet = CharacterSet.letters
            allowedCharacterSet.insert(charactersIn: " -")

            if string.rangeOfCharacter(from: allowedCharacterSet.inverted) != nil {
                showFormatErrorAlert()
                return false
            }
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == locationTextView {
            notes = textView.text ?? ""
        }
    }
}
//Импортрровать import FirebaseAuth
//import GoogleSignIn
//import FirebaseCore

//Получение данных в зависимости от метода // "app" / "google"
//UserDefaults.standard.set("google", forKey: "method")

//app
//UserDefaults.standard.set(name, forKey: "firstName")
//UserDefaults.standard.set(lastName, forKey: "lastName")
//UserDefaults.standard.set(email, forKey: "email")

//google
//if let user = Auth.auth().currentUser {
//    print("Имя: \(user.displayName ?? "N/A")")
//    print("Email: \(user.email ?? "N/A")")
//    print("Фото: \(user.photoURL?.absoluteString ?? "N/A")")
//}


//MARK: - Localization

extension ProfileViewController {
private func addObserverForLocalization() {
    NotificationCenter.default.addObserver(forName: LanguageManager.languageDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
        self?.updateLocalizedText()
    }
}

private func removeObserverForLocalization() {
    NotificationCenter.default.removeObserver(self, name: LanguageManager.languageDidChangeNotification, object: nil)
}

@objc func updateLocalizedText() {
    firstNameLabel.text = "First Name".localized()
    lastNameLabel.text = "Last Name".localized()
    emailLabel.text = "E-mail".localized()
    dobLabel.text = "Date of Birth".localized()
    genderLabel.text = "Gender".localized()
    locationLabel.text = "Location".localized()
    
    firstNameTextField.placeholder = "First Name".localized()
    lastNameTextField.placeholder = "Last Name".localized()
    emailTextField.placeholder = "E-mail".localized()
    locationTextView.placeholder = "Location".localized()
    
    maleButton.setTitle("Male".localized(), for: .normal)
    femaleButton.setTitle("Female".localized(), for: .normal)
    
    saveButton.setTitle("Save Changes".localized(), for: .normal)
    title = "Profile".localized()

}
}

