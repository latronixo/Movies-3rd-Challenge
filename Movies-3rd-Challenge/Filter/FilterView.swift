//
//  FilterView.swift
//  Movies-3rd-Challenge
//
//  Created by Александр Семёнов on 03.04.2025.
//

import UIKit

// Протокол для взаимодействия с FilterViewController
protocol FilterViewDelegate: AnyObject {
    // Вызывается при нажатии на кнопку закрытия
    func didTapCloseButton()
    
    // Вызывается при нажатии на кнопку сброса фильтров
    func didTapResetFiltersButton()
    
    // Вызывается при нажатии на кнопку применения фильтров
    func didTapApplyFiltersButton()
}

// View для отображения экрана фильтров
class FilterView: UIView {
    
    // Выбранная категория
    var selectedCategory: String?
    
    // Выбранный рейтинг
    var selectedRating: Int?

    // Делегат для обработки действий пользователя
    weak var delegate: FilterViewDelegate?
    
    // MARK: - UI Elements
    
    // Верхняя панель заголовка
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Заголовок экрана
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter".localized()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Кнопка закрытия экрана
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Кнопка сброса фильтров
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Filters".localized(), for: .normal)
        button.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.8, alpha: 1.0) // Фиолетовый цвет
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Заголовок раздела категорий
    private let categoriesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories".localized()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Заголовок раздела рейтингов
    private let ratingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Star Rating".localized()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Коллекция для отображения категорий
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // Меняем на вертикальное направление
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize // Включаем автоматический размер
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(FilterCategoryCell.self, forCellWithReuseIdentifier: FilterCategoryCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // Коллекция для отображения рейтингов
    private lazy var ratingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // Меняем на вертикальное направление
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize // Включаем автоматический размер
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(FilterRatingCell.self, forCellWithReuseIdentifier: FilterRatingCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // Кнопка применения фильтров
    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filters".localized(), for: .normal)
        button.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.8, alpha: 1.0) // Фиолетовый цвет
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Data
    
    // Массив доступных категорий
    private let categories = Constants.genres
    
    // Массив доступных рейтингов (количество звезд)
    private let ratings = [1, 2, 3, 4, 5]
    
    // Индекс выбранной категории
    private var selectedCategoryIndex: IndexPath?
    
    // Индекс выбранного рейтинга
    private var selectedRatingIndex: IndexPath?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    // Настройка интерфейса
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // Добавление компонентов
        addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(closeButton)
        headerView.addSubview(resetButton)
        
        addSubview(categoriesTitleLabel)
        addSubview(categoriesCollectionView)
        addSubview(ratingTitleLabel)
        addSubview(ratingCollectionView)
        addSubview(applyButton)
        
        // Констрейнты
        NSLayoutConstraint.activate([
            // Header
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            resetButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            resetButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // Categories
            categoriesTitleLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            categoriesTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            categoriesCollectionView.topAnchor.constraint(equalTo: categoriesTitleLabel.bottomAnchor, constant: 15),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 110), // Увеличиваем высоту для двух строк
            
            // Ratings
            ratingTitleLabel.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 20),
            ratingTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            ratingCollectionView.topAnchor.constraint(equalTo: ratingTitleLabel.bottomAnchor, constant: 15),
            ratingCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            ratingCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            ratingCollectionView.heightAnchor.constraint(equalToConstant: 110), // Увеличиваем высоту для двух строк
            
            // Apply Button
            applyButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -25),
            applyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            applyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            applyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Выбираем категорию, выбранную на экране Search. А по умолчанию - Все
        var indexOfDefaultSelectedCategory: Int? = 0
        if let selCategory = selectedCategory, let indexOfCategory = categories.firstIndex(of: selCategory) {
            indexOfDefaultSelectedCategory = indexOfCategory
        }
            let defaultCategoryIndex = IndexPath(item: indexOfDefaultSelectedCategory!, section: 0)
            categoriesCollectionView.selectItem(at: defaultCategoryIndex, animated: false, scrollPosition: .top)
            selectedCategoryIndex = defaultCategoryIndex
     
        if let selRating = selectedRating, let indexOfRating = ratings.firstIndex(of: selRating) {
            let defaultRatingIndex = IndexPath(item: indexOfRating, section: 0)
            ratingCollectionView.selectItem(at: defaultRatingIndex, animated: false, scrollPosition: .top)
        }
   }
    
    // Настройка обработчиков действий
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    // Обработчик нажатия на кнопку закрытия
    @objc private func closeButtonTapped() {
        delegate?.didTapCloseButton()
    }
    
    // Обработчик нажатия на кнопку сброса фильтров
    @objc private func resetButtonTapped() {
        // Сбрасываем выделение для рейтинга
        selectedRatingIndex = nil
        ratingCollectionView.selectItem(at: nil, animated: true, scrollPosition: .left)
        
        // Выбираем только All категорию
        let defaultCategoryIndex = IndexPath(item: 0, section: 0)
        categoriesCollectionView.selectItem(at: defaultCategoryIndex, animated: true, scrollPosition: .left)
        selectedCategoryIndex = defaultCategoryIndex
        
        delegate?.didTapResetFiltersButton()
    }
    
    // Обработчик нажатия на кнопку применения фильтров
    @objc private func applyButtonTapped() {
        delegate?.didTapApplyFiltersButton()
    }
    
    // MARK: - Public Methods
    
    // Обновляет выбранные фильтры в UI
    func updateSelectedFilters() {
        // Сначала сбрасываем все выделения
        categoriesCollectionView.selectItem(at: nil, animated: false, scrollPosition: .top)
        ratingCollectionView.selectItem(at: nil, animated: false, scrollPosition: .top)
        
        // Устанавливаем выбранную категорию
        if let selCategory = selectedCategory, let index = categories.firstIndex(of: selCategory) {
            let indexPath = IndexPath(item: index, section: 0)
            categoriesCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            selectedCategoryIndex = indexPath
        } else {
            // По умолчанию выбираем первую категорию
            let defaultCategoryIndex = IndexPath(item: 0, section: 0)
            categoriesCollectionView.selectItem(at: defaultCategoryIndex, animated: false, scrollPosition: .top)
            selectedCategoryIndex = defaultCategoryIndex
        }
        
        // Устанавливаем выбранный рейтинг
        if let selRating = selectedRating, let index = ratings.firstIndex(of: selRating) {
            let indexPath = IndexPath(item: index, section: 0)
            ratingCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            selectedRatingIndex = indexPath
        }
    }
    
    // Возвращает выбранную категорию
    func getSelectedCategory() -> String? {
        if let indexPath = selectedCategoryIndex {
            return categories[indexPath.item]
        }
        return nil
    }
    
    // Возвращает выбранный рейтинг
    func getSelectedRating() -> Int? {
        if let indexPath = selectedRatingIndex {
            return ratings[indexPath.item]
        }
        return nil
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension FilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    // Возвращает количество элементов в секции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return categories.count
        } else {
            return ratings.count
        }
    }
    
    // Создает и настраивает ячейку для отображения
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCategoryCell.identifier, for: indexPath) as! FilterCategoryCell
            cell.configure(with: categories[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterRatingCell.identifier, for: indexPath) as! FilterRatingCell
            cell.configure(with: ratings[indexPath.item])
            return cell
        }
    }
    
    // Обрабатывает выбор ячейки
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            selectedCategoryIndex = indexPath
        } else {
            selectedRatingIndex = indexPath
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FilterView: UICollectionViewDelegateFlowLayout {
    // Определяет размер для каждой ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollectionView {
            // Динамически вычисляем ширину ячейки на основе текста
            let categoryText = categories[indexPath.item]
            let font = UIFont.systemFont(ofSize: 14, weight: .medium)
            let textSize = categoryText.size(withAttributes: [NSAttributedString.Key.font: font])
            
            // Добавляем отступы с обеих сторон и учитываем радиус скругления
            let width = textSize.width + 50 // Увеличиваем общий отступ для текста
            return CGSize(width: width, height: 40)
        } else {
            // Для рейтинга - вычисляем ширину на основе количества звезд
            let starCount = ratings[indexPath.item]
            let starSize: CGFloat = 20 // Размер одной звезды
            let spacing: CGFloat = 4 // Расстояние между звездами
            
            // Вычисляем ширину: (количество звезд * размер) + расстояние между звездами + отступы
            let width = CGFloat(starCount) * starSize + CGFloat(starCount - 1) * spacing + 40 // Увеличиваем общий отступ для звезд
            return CGSize(width: width, height: 40)
        }
    }
    
    // Настраиваем отступы между секциями
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // Настраиваем минимальное расстояние между ячейками по горизонтали
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // Настраиваем минимальное расстояние между строками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

