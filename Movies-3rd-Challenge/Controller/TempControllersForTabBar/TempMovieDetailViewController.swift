//
//  TempMovieDetailViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Валентин Картошкин on 31.03.2025.
//
import UIKit

class TempMovieDetailViewController: UIViewController {
    private let mainView: TempMovieDetailView = .init()
    var movie: MoviewDetailResponse
    
    init(movie: MoviewDetailResponse) {
        self.movie = movie
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
