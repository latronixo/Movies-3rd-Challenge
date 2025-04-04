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
        navigationBarSetup()
        mainView.openTextButton.addTarget(self, action: #selector(showTextDescription), for: .touchUpInside)
    }
    
    //MARK: NAVIGATION BAR
    func navigationBarSetup() {
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
                .font: UIFont.boldSystemFont(ofSize: 20)])
        
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "suit.heart"),
            style: .plain,
            target: self,
            action: #selector(doneTapped))
        rightButton.tintColor = .black
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
