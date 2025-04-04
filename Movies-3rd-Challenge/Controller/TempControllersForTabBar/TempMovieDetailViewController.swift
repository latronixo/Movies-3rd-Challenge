//
//  TempMovieDetailViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 31.03.2025.
//
import UIKit

class TempMovieDetailViewController: UIViewController {
    private let mainView: TempMovieDetailView = .init()
    private var movieID: Int
    private var descriptionIsOpen: Bool = false
    
    init(movie: Int) {
        self.movieID = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        //MARK: NAVIGATION BAR
            let backButton = UIBarButtonItem(
                image: UIImage(named: "Arrow Back"),
                style: .plain,
                target: self,
                action: #selector(backTapped))
            backButton.tintColor = .black
            
            let titleLabel = UILabel()
            titleLabel.attributedText = NSAttributedString(
                string: "Movie Detail",
                attributes: [
                    .font: UIFont(name: "PlusJakartaSans-ExtraBold", size: 18) ?? UIFont.systemFont(ofSize: 18)])
            
            let rightButton = UIBarButtonItem(
                image: UIImage(systemName: "suit.heart"),
                style: .plain,
                target: self,
                action: #selector(heartTapped))
            rightButton.tintColor = .black
            
            self.navigationItem.titleView = titleLabel
            self.navigationItem.rightBarButtonItem = rightButton
            self.navigationItem.leftBarButtonItem = backButton
            self.navigationItem.hidesBackButton = true
        mainView.openTextButton.addTarget(self, action: #selector(showTextDescription), for: .touchUpInside)

    }

    @objc func heartTapped() {
        var isFavorite: Bool = CoreDataManager.shared.isMovieInFavorites(withId: self.movieID)
        if isFavorite == true {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "suit.heart.fill")
            self.navigationItem.rightBarButtonItem?.tintColor = .red
            CoreDataManager.shared.deleteMovie(withId: self.movieID)
        } else {
//            let favoriteMovie: Movie = загрузить мувик и передать его для сохранения в CoreData
//            CoreDataManager.shared.saveMovie(favoriteMovie: <#T##Movie#>)
        }
    }
    //MARK: NavigationFunctions
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func warchNowTapped() {
        //прописать переход на другой контроллер
    }
    //MARK: ShowDescription
    @objc func showTextDescription() {
        descriptionIsOpen.toggle()
        if descriptionIsOpen {
            mainView.descriptionOfMovie.numberOfLines = 0
            mainView.openTextButton.setTitle("Скрыть", for: .normal)
        } else {
            mainView.descriptionOfMovie.numberOfLines = 3
            mainView.openTextButton.setTitle("Показать все", for: .normal)
        }
    }
    private func rePrintStars() {
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
