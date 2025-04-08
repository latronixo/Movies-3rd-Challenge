//
//  CustomAlert.swift
//  Movies-3rd-Challenge
//
//  Created by Anna Melekhina on 03.04.2025.
//

import UIKit

class AvatarViewController: UIViewController {

    var onTakePhoto: (() -> Void)?
    var onChoosePhoto: (() -> Void)?
    var onDeletePhoto: (() -> Void)?
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Change your picture"
        label.font = .boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var takePhotoButton = makeButton(title: "Take a photo", systemIcon: "camera", action: #selector(takePhotoTapped))
    private lazy var chooseFileButton = makeButton(title: "Choose from your file", systemIcon: "folder", action: #selector(chooseFileTapped))
    private lazy var deleteButton = makeButton(title: "Delete Photo", systemIcon: "trash", action: #selector(deletePhotoTapped), tint: .systemRed)

    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(blurView)
        view.addSubview(alertView)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        blurView.addGestureRecognizer(tap)

        setupLayout()
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

    private func setupLayout() {
        view.addSubview(alertView)
        [titleLabel, takePhotoButton, chooseFileButton, deleteButton].forEach { alertView.addSubview($0) }

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),

            takePhotoButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            takePhotoButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            takePhotoButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16),
            takePhotoButton.heightAnchor.constraint(equalToConstant: 44),
            
            chooseFileButton.topAnchor.constraint(equalTo: takePhotoButton.bottomAnchor, constant: 12),
            chooseFileButton.leadingAnchor.constraint(equalTo: takePhotoButton.leadingAnchor),
            chooseFileButton.trailingAnchor.constraint(equalTo: takePhotoButton.trailingAnchor),
            chooseFileButton.heightAnchor.constraint(equalToConstant: 44),

            deleteButton.topAnchor.constraint(equalTo: chooseFileButton.bottomAnchor, constant: 12),
            deleteButton.leadingAnchor.constraint(equalTo: takePhotoButton.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: takePhotoButton.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),

            deleteButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20)
        ])
    }

    private func makeButton(title: String, systemIcon: String, action: Selector, tint: UIColor = .label) -> UIButton {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: systemIcon)
        config.title = title
        config.imagePadding = 8
        config.baseForegroundColor = tint
        config.baseBackgroundColor = .secondarySystemBackground
        config.cornerStyle = .medium
        button.configuration = config
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    @objc private func takePhotoTapped() {
        dismiss(animated: true) { self.onTakePhoto?() }
    }

    @objc private func chooseFileTapped() {
        dismiss(animated: true) { self.onChoosePhoto?() }
    }

    @objc private func deletePhotoTapped() {
        dismiss(animated: true) { self.onDeletePhoto?() }
    }

    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

extension AvatarViewController {
    
    private func addObserverForLocalization() {
        NotificationCenter.default.addObserver(forName: LanguageManager.languageDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateLocalizedText()
        }
    }
    
    private func removeObserverForLocalization() {
        NotificationCenter.default.removeObserver(self, name: LanguageManager.languageDidChangeNotification, object: nil)
    }
    
    func updateLocalizedText() {
        titleLabel.text = "Change your picture".localized()
        takePhotoButton.setTitle("Take a photo".localized(), for: .normal)
        chooseFileButton.setTitle( "Choose from your file".localized(), for: .normal)
        deleteButton.setTitle("Delete Photo".localized(), for: .normal)
    }
}
