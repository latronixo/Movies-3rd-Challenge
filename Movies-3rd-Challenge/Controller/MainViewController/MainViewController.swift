//
//  MainViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Anna Melekhina on 01.04.2025.
//

import UIKit

final class MainViewController: UIViewController {

    //MARK: ui elements
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private lazy var topCollectionView: UICollectionView = {
        let topLayout = ArcLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: topLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TopCell.self, forCellWithReuseIdentifier: "TopCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = banners.count
        pageControl.currentPage = 1
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = UIColor(named: "mainViolet")
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
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
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()

    private lazy var headerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarImageView, greetingLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        return imageView
    }()

    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, name 👋"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var boxOfficeLabel: UILabel = {
        let label = UILabel()
        label.text = "Box Office"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.tintColor = UIColor(named: "mainViolet")
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(seeAllTapped), for: .touchUpInside)
        return button
    }()
    
    let banners = ["thor", "encanto", "encanto", "encanto", "seabeast"]
    let movies = ["Drifting Home", "Jurassic World"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupScrollView()
        setupUI()
    }

    // MARK: private methods
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupUI() {
        
        navigationController?.isNavigationBarHidden = true
        
        contentView.addSubview(topCollectionView)
        contentView.addSubview(categoryCollectionView)
        contentView.addSubview(tableView)
        contentView.addSubview(pageControl)
        contentView.addSubview(headerStack)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(boxOfficeLabel)
        contentView.addSubview(seeAllButton)

        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            topCollectionView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 0),
            topCollectionView.heightAnchor.constraint(equalToConstant: 300),
            topCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            pageControl.topAnchor.constraint(equalTo: topCollectionView.bottomAnchor, constant: 0),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 5),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            categoryCollectionView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 40),
            categoryCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            boxOfficeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            boxOfficeLabel.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 20),
            
            seeAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            seeAllButton.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 20),

            tableView.topAnchor.constraint(equalTo: boxOfficeLabel.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(movies.count * 80)),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func seeAllTapped() {
        print("открыть экран си олл")
    }
}

// MARK: CollectionView

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            return banners.count
        } else {
            return categories.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCell
            cell.configure(with: banners[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.configure(title: categories[indexPath.item])
            return cell
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == topCollectionView {
            let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
            pageControl.currentPage = page
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topCollectionView {
            return CGSize(width: collectionView.bounds.width - 32, height: 220)
        } else {
            let title = categories[indexPath.item]
            let width = (title as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width + 32
            return CGSize(width: width, height: 32)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                    withVelocity velocity: CGPoint,
                                    targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == topCollectionView else { return }
        guard let layout = topCollectionView.collectionViewLayout as? ArcLayout else { return }
        guard let cv = layout.collectionView else { return }

        let maxOffsetX = layout.collectionViewContentSize.width - cv.bounds.width
        let proposedOffset = targetContentOffset.pointee.x

        let currentAngle = layout.angleAtExtreme * proposedOffset / maxOffsetX
        let index = round(-currentAngle / layout.anglePerItem)

        let newAngle = -layout.anglePerItem * index
        let newOffset = (newAngle / layout.angleAtExtreme) * maxOffsetX

        targetContentOffset.pointee = CGPoint(x: newOffset, y: 0)
    }

}

// MARK: TableView

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        cell.configure(title: movies[indexPath.row], rating: "111", imageName: "miniPoster")
        return cell
    }
}



#Preview { MainViewController()}
