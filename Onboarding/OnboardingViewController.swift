//
//  OnboardingViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Александр Семёнов on 31.03.2025.
//
import UIKit


final class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    private let onboardingView = OnboardingView()
    
    private let slides: [(image: String, title: String, description: String)] = [
        ("FirstSlide", "Watch your favorite movie easily", "Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem ."),
        ("SecondSlide", "Watch your favorite movie easily", "Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem ."),
        ("TomCruse", "Watch your favorite movie easily", "Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem ."),
    ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 332, height: 614) // Устанавливаем фиксированный размер ячейки
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(OnboardingCell.self, forCellWithReuseIdentifier: "OnboardingCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.clipsToBounds = false // Важно! Отключаем обрезку содержимого
        return cv
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .onboardingBG
        pc.pageIndicatorTintColor = .systemGray5
        pc.translatesAutoresizingMaskIntoConstraints = false
        
        // Настраиваем размер точек
        pc.preferredIndicatorImage = UIImage.circle(diameter: 6)
        pc.preferredCurrentPageIndicatorImage = UIImage.circle(diameter: 6)
        
        return pc
    }()
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func loadView() {
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        
        pageControl.numberOfPages = slides.count
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5) // Увеличиваем размер точек
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -335),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 160),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -160)
        ])
    }
    
    @objc private func slideButtonTapped() {
        print("I'mtapped")
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "OnboardingCell",
            for: indexPath
        ) as! OnboardingCell
        
        let slide = slides[indexPath.item]
        let isLastCell = indexPath.item == slides.count - 1
        cell.configure(
            image: slide.image,
            title: slide.title,
            description: slide.description,
            isLastCell: isLastCell
        )
        
        // Добавляем обработчик нажатия на кнопку
        if isLastCell {
            cell.imageView.clipsToBounds = true
            cell.slideButton.setTitle("Start", for: .normal)
            
            cell.slideButton.addTarget(
                    self,
                    action: #selector(slideButtonTapped),
                    for: .touchUpInside
                )
        } else {
            cell.slideButton.setTitle("Continue", for: .normal)
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = Int(page)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 75 // Добавляем отступ между карточками
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth: CGFloat = 326
        let inset = (screenWidth - cellWidth) / 2
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}

