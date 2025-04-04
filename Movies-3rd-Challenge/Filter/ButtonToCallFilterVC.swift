//
//  ButtonToCallFilterVC.swift
//  Movies-3rd-Challenge
//
//  Created by Александр Семёнов on 03.04.2025.
//

import UIKit

// Контроллер с кнопкой для вызова экрана фильтра
class ButtonToCallFilterVC: UIViewController {
    
    // MARK: - Properties
    
    // Выбранная категория фильтра
    private var selectedCategory: String?
    
    // Выбранный рейтинг фильтра
    private var selectedRating: Int?
    
    // Кнопка для открытия экрана фильтра
    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Открыть фильтр", for: .normal)
        button.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.8, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Метка для отображения выбранных фильтров
    private let selectedFiltersLabel: UILabel = {
        let label = UILabel()
        label.text = "Выбранные фильтры: нет"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    
    // Настройка пользовательского интерфейса
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Экран с кнопкой фильтра"
        
        view.addSubview(filterButton)
        view.addSubview(selectedFiltersLabel)
        
        NSLayoutConstraint.activate([
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 200),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            
            selectedFiltersLabel.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 30),
            selectedFiltersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectedFiltersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Настройка цвета текста для поддержки темной темы
        selectedFiltersLabel.textColor = .label
        
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    // Обработчик нажатия на кнопку открытия фильтра
    @objc private func filterButtonTapped() {
        let filterVC = FilterViewController()
        filterVC.delegate = self
        
        // Передаем текущие значения фильтров, если они есть
        filterVC.setInitialFilters(category: selectedCategory, rating: selectedRating)
        
        present(filterVC, animated: true)
    }
    
    // MARK: - Helper Methods
    
    // Обновляет текст метки с выбранными фильтрами
    private func updateSelectedFiltersLabel() {
        var filterText = "Выбранные фильтры: "
        
        if let category = selectedCategory, let rating = selectedRating {
            filterText += "категория - \(category), рейтинг - \(rating) звезд"
        } else if let category = selectedCategory {
            filterText += "категория - \(category)"
        } else if let rating = selectedRating {
            filterText += "рейтинг - \(rating) звезд"
        } else {
            filterText += "нет"
        }
        
        selectedFiltersLabel.text = filterText
    }
}

// MARK: - FilterViewControllerDelegate

extension ButtonToCallFilterVC: FilterViewControllerDelegate {
    // Вызывается когда пользователь применяет фильтры
    func filterViewController(_ controller: FilterViewController, didApplyFilters category: String?, rating: Int?) {
        selectedCategory = category
        selectedRating = rating
        updateSelectedFiltersLabel()
    }
    
    // Вызывается когда пользователь сбрасывает фильтры
    func filterViewControllerDidReset(_ controller: FilterViewController) {
        selectedCategory = nil
        selectedRating = nil
        updateSelectedFiltersLabel()
    }
} 
