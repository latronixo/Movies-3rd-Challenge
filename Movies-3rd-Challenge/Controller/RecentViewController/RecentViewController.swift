import UIKit

class RecentViewController: BaseMovieListController {
    
    private lazy var categoryCollectionView: UICollectionView = {
        let catLayout = UICollectionViewFlowLayout()
        catLayout.scrollDirection = .horizontal
        catLayout.minimumLineSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: catLayout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        setTitleUpper(navItem: navigationItem, title: "Recent Watch")
        setupCategoryFilter()
        setupConstraints()
    }
    
    override func loadData() {
        //movies = TempDataManager.shared.getFavorites()
        movies = [movie1, movie1, movie1, movie1]
        tableView.reloadData()
        categoryCollectionView.reloadData()
    }
    
    private func setupCategoryFilter() {
        //        categoryFilterView.onCategorySelected = { [weak self] category in
        //            self?.filterMovies(by: category)
        //        }
        //        view.addSubview(categoryFilterView)
        //
        //        private func filterMovies(by category: String) {
        //            // Фильтрация списка
        //        }
        
        view.addSubview(categoryCollectionView)
        view.bringSubviewToFront(categoryCollectionView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 40),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension RecentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.configure(title: categories[indexPath.item])
        return cell
    }
    
}
extension RecentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = categories[indexPath.item]
        let width = title.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width + 20
        return CGSize(width: width, height: 40)
    }
}
