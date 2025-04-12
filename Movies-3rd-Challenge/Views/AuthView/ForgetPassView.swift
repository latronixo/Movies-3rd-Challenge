//
//  ForgetPass.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 08.04.2025.
//

import Foundation
import UIKit

class ForgetPassView: UIView {
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
        textField.keyboardType = .emailAddress
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
    lazy var textFieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var submit: UIButton = {
        let signUpButton = UIButton()
        signUpButton.setTitle("Submit", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = UIColor(named: "Button")
        signUpButton.layer.cornerRadius = 24
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        return signUpButton
    }()
    init() {
        super.init(frame: .zero)
        setView()
        setConstraint()
    }
    
    func setView(){
        addSubview(textFieldsStackView)
        addSubview(submit)
        
    }
    func setConstraint(){
        NSLayoutConstraint.activate([
            textFieldsStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            textFieldsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            textFieldsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            
            submit.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            submit.centerXAnchor.constraint(equalTo: centerXAnchor),
            submit.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
