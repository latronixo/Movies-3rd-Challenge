//
//  SearchViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 01.04.2025.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private var searchText: String = ""
    private var selectedGenre: String?
    private var selectedRating: Int?
    var movies: [Movie] = []
    private var isLoading = false
    private var currentPage = 1
    private let limit = 10

    private var genresList: [GenreItem] = GenreProvider.genres(for: LanguageManager.shared.currentLanguage)


    // Таймер для задержки поиска
    private var searchTimer: Timer?

    private let networkManager = NetworkService.shared
    private let apiKey = ""

    //флаг для исключения повторного открытия MovieDetail
    private var isNavigatingToDetail = false
    
    // MARK: - UI Components
    
    private lazy var searchBar: UIView = {
        let container = UIView()
        container.backgroundColor = .clear
        
        // Основное текстовое поле
        let textField = UITextField()
        textField.placeholder = "Search for movies"
        textField.tag = 101
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.4, green: 0.4, blue: 0.8, alpha: 1.0).cgColor
        textField.layer.cornerRadius = 25
        textField.clipsToBounds = true
        textField.leftViewMode = .always
        textField.delegate = self
        textField.clearButtonMode = .never
        textField.textColor = .label
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search for movies",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        )
        
        // Иконка поиска слева
        let searchIcon = UIImageView(image: UIImage(named: "searchIcon"))
        searchIcon.tintColor = .secondaryLabel
        searchIcon.contentMode = .scaleAspectFit
        let searchIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        searchIcon.frame = CGRect(x: 10, y: 5, width: 18, height: 18)
        searchIconContainer.addSubview(searchIcon)
        textField.leftView = searchIconContainer
        
        // Кнопка крестика (внутри текстового поля, слева от фильтра)
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = .secondaryLabel
        clearButton.addTarget(self, action: #selector(clearSearch), for: .touchUpInside)
        
        // Кнопка фильтра (внутри текстового поля справа)
        let filterButton = UIButton(type: .custom)
        filterButton.setImage(UIImage(named: "filterIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        filterButton.tintColor = .secondaryLabel
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        // Контейнер для правых кнопок
        let rightButtonsContainer = UIView()
        rightButtonsContainer.addSubview(clearButton)
        rightButtonsContainer.addSubview(filterButton)
        
        // Расположение кнопок в контейнере
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clearButton.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor),
            clearButton.centerYAnchor.constraint(equalTo: rightButtonsContainer.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 30),
            clearButton.heightAnchor.constraint(equalToConstant: 30),
            
            filterButton.trailingAnchor.constraint(equalTo: rightButtonsContainer.trailingAnchor, constant: -10),
            filterButton.centerYAnchor.constraint(equalTo: rightButtonsContainer.centerYAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 30),
            filterButton.heightAnchor.constraint(equalToConstant: 30),
            
            rightButtonsContainer.widthAnchor.constraint(equalToConstant: 68), // 30 + 8 + 30
            rightButtonsContainer.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        textField.rightView = rightButtonsContainer
        textField.rightViewMode = .always
        
        container.addSubview(textField)
        
        // Констрейнты для текстового поля
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            textField.topAnchor.constraint(equalTo: container.topAnchor),
            textField.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.searchTextField = textField
        return container
    }()
    // Добавьте эти свойства в класс
    private weak var searchTextField: UITextField!
    private weak var clearButton: UIButton!
    
    private lazy var genreScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()

    private lazy var categoryCollectionView: UICollectionView = {
        let catLayout = UICollectionViewFlowLayout()
        catLayout.scrollDirection = .horizontal
        catLayout.minimumLineSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: catLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.rowHeight = 184
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .systemGray
        return indicator
    }()

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleUpper(navItem: navigationItem, title: "Search")
        
        // Устанавливаем цвет фона в зависимости от темы
        view.backgroundColor = .systemBackground
        
        //убираем разделители между ячейками
        tableView.separatorStyle = .none

        setupUI()
        setupConstraints()
        
        updateLocalizedText()
        
        // Добавляем наблюдатель за изменением темы
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(updateTheme),
//            name: UIApplication.didBecomeActiveNotification,
//            object: nil
//        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserverForLocalization()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverForLocalization()
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(categoryCollectionView)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateLabel)
        
        setupConstraints()
    }
    
    @objc private func clearSearch() {
        searchTextField.text = ""
        searchText = ""
        currentPage = 1
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        genreScroll.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50),

            categoryCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
        //загружаем фильмы при переходе из БоксОфис
    func updateWithBoxOffice(movies: [Movie]) {
        self.movies = movies
        self.tableView.reloadData()

    }
    
    // MARK: - State Management

    private func showLoading() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        emptyStateLabel.isHidden = true
    }

    private func hideLoading() {
        activityIndicator.stopAnimating()
        tableView.isHidden = false
    }

    private func showEmptyState(message: String) {
        emptyStateLabel.text = message
        emptyStateLabel.isHidden = false
        tableView.isHidden = true
    }

    // MARK: - Networking
    private func loadMoviesByName() {
        guard !isLoading, !searchText.isEmpty else { return }
        
        showLoading()
        isLoading = true
        
        networkManager.fetchMovies(currentPage, searchText) { [weak self] newMovies in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.hideLoading()
                
                if self.currentPage == 1 {
                    self.movies = newMovies
                } else {
                    self.movies.append(contentsOf: newMovies)
                }
                
                if self.movies.isEmpty {
                    self.showEmptyState(message: "По вашему запросу ничего не найдено.\nПопробуйте изменить параметры поиска.")
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    private func loadMoviesWithFilters() {
        guard !isLoading else { return }
        
        showLoading()
        isLoading = true
        
        networkManager.fetchMovies(currentPage, selectedGenre, selectedRating) { [weak self] newMovies in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.hideLoading()
                
                if self.currentPage == 1 {
                    self.movies = newMovies
                } else {
                    self.movies.append(contentsOf: newMovies)
                }
                
                if self.movies.isEmpty {
                    self.showEmptyState(message: "Фильмы по выбранным фильтрам не найдены.\nПопробуйте изменить параметры поиска.")
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Genre Button Actions
    //нажатие на кнопку с фильтрами - вызов алерта с фильтрами
    @objc private func filterButtonTapped() {
        
        let filterVC = FilterViewController()
        filterVC.delegate = self
        filterVC.setInitialFilters(category: selectedGenre, rating: selectedRating)
        
        present(filterVC, animated: true)
    }

}

// MARK: - FilterViewControllerDelegate

extension SearchViewController: FilterViewControllerDelegate {
    // Вызывается когда пользователь применяет фильтры в алерте
    func filterViewController(_ controller: FilterViewController, didApplyFilters category: String?, rating: Int?) {
        selectedGenre = category
        selectedRating = rating
        
        // Обновляем выделение категории в коллекции
        updateCategorySelectionInCollection()
        
        // Сбрасываем страницу и загружаем фильмы с новыми фильтрами
        currentPage = 1
        movies.removeAll()
        loadMoviesWithFilters()
        tableView.reloadData()
    }

    // Вызывается когда пользователь сбрасывает фильтры
    func filterViewControllerDidReset(_ controller: FilterViewController) {
        selectedGenre = nil
        selectedRating = nil
        
        // Обновляем выделение категории в коллекции (выбираем первую категорию при сбросе)
        updateCategorySelectionInCollection()
        
        // Сбрасываем страницу и загружаем фильмы без фильтров
        currentPage = 1
        movies.removeAll()
        loadMoviesWithFilters()
        tableView.reloadData()
    }
    
    // Метод для обновления выделения категории в коллекции жанров
    private func updateCategorySelectionInCollection() {
        // Полностью перезагружаем коллекцию для корректного обновления всех ячеек
        // Это наиболее надежный способ обновить выделение
        categoryCollectionView.reloadData()
        
        // После перезагрузки выделяем нужную ячейку
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            var indexPathToSelect: IndexPath
            
            if let selectedGenre = self.selectedGenre,
                       let index = self.genresList.firstIndex(where: { $0.queryValue == selectedGenre }) {
                        indexPathToSelect = IndexPath(item: index, section: 0)
                    } else {
                        indexPathToSelect = IndexPath(item: 0, section: 0)
                    }
            
            // Выделяем ячейку и скроллим, чтобы она была видна
            self.categoryCollectionView.selectItem(at: indexPathToSelect, animated: true, scrollPosition: .centeredHorizontally)
            
            // Также устанавливаем isCellSelected для выбранной ячейки
            if let cell = self.categoryCollectionView.cellForItem(at: indexPathToSelect) as? CategoryCell {
                cell.isCellSelected = true
            }
        }
    }
}



// MARK: - UITableViewDataSource
//делегаты для таблицы с фильмами
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    //обработка события окончания пролистывания таблицы (каждый свайп вниз или вверх (закомментировал, потому что при разработке попусту тратит лимит на количество запросов в сутки. Если до защиты останется время, можно будет раскомментировать и проверить, работает или нет)
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        let lastSectionIndex = tableView.numberOfSections - 1
//        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
//        
//        if indexPath.section == lastSectionIndex &&
//           indexPath.row == lastRowIndex && !isLoading {
//            // Загружаем следующую страницу при прокрутке до последней ячейки
//            currentPage += 1
//            loadMovies()
//            print("подгружаю еще 10 фильмов, страничку \(currentPage)...")
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard !isNavigatingToDetail else { return } // Если переход уже выполняется, игнорируем повторное нажатие
        isNavigatingToDetail = true                 // Устанавливаем флаг
        
        let selectedMovie = movies[indexPath.item]
        guard let id = selectedMovie.id else {
            isNavigatingToDetail = false // Сбрасываем флаг при ошибке
            return
        }
        
        NetworkService.shared.fetchMovieDetail(id: id) { [weak self] detail in
            guard let detail = detail else {
                self?.isNavigatingToDetail = false // Сбрасываем флаг при ошибке
                return
            }
            DispatchQueue.main.async {
                let vc = TempMovieDetailViewController(movie: selectedMovie, detail: detail)
                vc.hidesBottomBarWhenPushed = true  //скрываем таббар
                self?.navigationController?.pushViewController(vc, animated: true)
                self?.isNavigatingToDetail = false // Сбрасываем флаг после завершения перехода
            }
        }
    }

}

// MARK: - UISearchBarDelegate
extension SearchViewController: UITextFieldDelegate {
    
    //нажатие на Enter в поле поиска
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Скрываем клавиатуру
        textField.resignFirstResponder()
        
        // Проверяем, есть ли текст в поле поиска
        if let searchText = textField.text, !searchText.isEmpty {
            self.searchText = searchText
            goSearchByName()
        }
        
        return true
    }
    
    //событие ввода символа в поле поиска. Спустя 3 секунды загружаем список фильмов в tableView
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchTimer?.invalidate()
        
        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        if updatedText.isEmpty {
            clearSearch()
            showEmptyState(message: "Введите название фильма для поиска")
            return true
        } else {
            resetGenreSelection()
        }
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.searchText = updatedText
            self.goSearchByName()
        }
        
        return true
    }
    
    func goSearchByName() {
        self.currentPage = 1
        self.loadMoviesByName()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    private func resetGenreSelection() {
        // Снимаем выделение со всех ячеек
        categoryCollectionView.visibleCells.forEach { cell in
            if let categoryCell = cell as? CategoryCell {
                categoryCell.isCellSelected = false
            }
        }
        
        // Выбираем первую ячейку ("Все")
        let defaultIndexPath = IndexPath(item: 0, section: 0)
        categoryCollectionView.selectItem(at: defaultIndexPath, animated: true, scrollPosition: .left)
        if let defaultCell = categoryCollectionView.cellForItem(at: defaultIndexPath) as? CategoryCell {
            defaultCell.isCellSelected = true
        }
        
        selectedGenre = nil
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genresList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let genreItem = genresList[indexPath.item]
        cell.configure(title: genreItem.displayName)
        
        if let selectedGenre = selectedGenre {
            // Сравниваем queryValue, потому что selectedGenre — это значение, отправляемое в API (на русском)
            cell.isCellSelected = genreItem.queryValue == selectedGenre
        } else {
            cell.isCellSelected = indexPath.item == 0
        }
        
        return cell
    }

  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        	let genreItem = genresList[indexPath.item]

        // Обновляем состояние всех видимых ячеек
        collectionView.visibleCells.forEach { cell in
            if let categoryCell = cell as? CategoryCell {
                categoryCell.isCellSelected = false
            }
        }
        
        // Обновляем выбранную ячейку
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
            selectedCell.isCellSelected = true
        }
        
        self.selectedGenre = genreItem.queryValue
        loadMoviesWithFilters()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = genresList[indexPath.item].displayName
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = title
        
        let width = label.intrinsicContentSize.width + 32 // Добавляем отступы
        return CGSize(width: max(width, 60), height: 32)
    }
}

// MARK: - UI Improvements
extension SearchViewController {
     // Добавление тени под tableView
     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         tableView.layer.shadowPath = UIBezierPath(rect: tableView.bounds).cgPath
         tableView.layer.shadowColor = UIColor.lightGray.cgColor
         tableView.layer.shadowOpacity = 0.3
         tableView.layer.shadowRadius = 5
         tableView.layer.shadowOffset = CGSize(width: 0, height: 5)
     }
}

// MARK: - Error Handling
extension SearchViewController {
     // Обработка ошибок API
     private func handleError(_ error: Error) {
         let alert = UIAlertController(
             title: "Ошибка".localized(),
             message: "Не удалось загрузить данные. Проверьте подключение к интернету.".localized(),
             preferredStyle: .alert
         )
         
         alert.addAction(UIAlertAction(
             title: "Повторить".localized(),
             style: .default
         ) { [weak self] _ in
             self?.loadMoviesByName()
         })
     
     present(alert, animated: true)
     }
}

extension SearchViewController {
    
    private func addObserverForLocalization() {
        NotificationCenter.default.addObserver(forName: LanguageManager.languageDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateLocalizedText()
        }
    }
    
    private func removeObserverForLocalization() {
        NotificationCenter.default.removeObserver(self, name: LanguageManager.languageDidChangeNotification, object: nil)
    }
    
    func updateLocalizedText() {
        
        setTitleUpper(navItem: navigationItem, title: "Search".localized())
        
        if let textField = searchBar.viewWithTag(101) as? UITextField {
            textField.placeholder = "Search for movies".localized()
        }
        
        genresList = GenreProvider.genres(for: LanguageManager.shared.currentLanguage)
        categoryCollectionView.reloadData()
    }
}

