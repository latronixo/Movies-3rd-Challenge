//
//  TempMovieDetailViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 31.03.2025.
//

import UIKit

class TempMovieDetailViewController: UIViewController {
    private let mainView: TempMovieDetailView = .init()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: NAVIGATION BAR
        let backButton = UIBarButtonItem(
            image: UIImage(named: "Arrow Back"),
            style: .plain,
            target: self,
            action: #selector(backTapped))
        
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(
            string: "Movie Detail",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 20)])
        
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "suit.heart"),
            style: .plain,
            target: self,
            action: #selector(doneTapped))
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.hidesBackButton = true
    }
    
    @objc func doneTapped() {
        //проверка на наличие элементв в сохраненных
        //если нет, то добавить и закрасить сердечко
        // если есть, то удалить из избраннного
    }
            
    @objc func backTapped() {
                
    }

}
//MARK: CollectionView

extension TempMovieDetailViewController: UICollectionViewDelegate {
    
}
extension TempMovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}

// Задачи: Настроить Collectionview
// Добавить все элементы на экран
// Посмотреть зависимость от DarkMode

