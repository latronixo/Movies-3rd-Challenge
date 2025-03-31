//
//  TabBar.swift
//  OnlineStore-2nd-Challenge
//
//  Created by Валентин Картошкин on 05.03.2025.
//

import UIKit

//Кастомный tabBar для UITabBarController
class TabBar: UITabBar {
    private var indicatorView: UIView!  //индикатор (линия) под выбранной кнопкой (в UITabBarController)
    private lazy var topBorderLayer: CALayer = {    //серая линия сверху
        let element = CALayer()
        return element
    }()
    
    //задаем высоту таббара
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        //получаем стандартный размер
        var sizeThatFits = super.sizeThatFits(size)
        
        //устанавливаем высоту 10% от высоты экрана
        let screenHeight = UIScreen.main.bounds.height
        let customHeight = screenHeight * 0.1
        sizeThatFits.height = customHeight
        
        return sizeThatFits
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTopBorder()
        setupIndicator()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setTopBorder()
        setupIndicator()
    }
    
    func setupIndicator() {
        //создаем индикатор (линию)
        indicatorView = UIView()
        indicatorView.backgroundColor = .black //цвет линии
        self.addSubview(indicatorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //обновляем позицию индикатора
        updateIndicatorPosition()
        
        //обновляем frame слоя границы
        let borderHeight: CGFloat = 0.5 //Высота границы
        topBorderLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: borderHeight)
    }
    
    private func setTopBorder() {
        //создаем слой для верхней границы
//        topBorderLayer = CALayer()
        topBorderLayer.backgroundColor = UIColor.gray.cgColor   //цвет границы
        self.layer.addSublayer(topBorderLayer)
    }

    private func updateIndicatorPosition() {
        guard let items = self.items, items.count > 0 else { return }
        
        //ширина индикатора равна ширине TabBar, деленной на количество элементов, от этого уменьшаем на 60:
        let itemWidth = self.frame.width / CGFloat(items.count)
        let indicatorWidth = itemWidth * 0.17    //ширина линии (% от ширины кнопки)
        let indicatorHeight: CGFloat = 2

        //позиция индикатора
        let xPosition = itemWidth * CGFloat(selectedItem?.tag ?? 0) + (itemWidth - indicatorWidth) / 2
//        let bottomOffset: CGFloat = 14
//        let yPosition = self.frame.height - indicatorHeight - bottomOffset
        
        let yPosition = self.frame.height * 0.5
        
        //обновляем frame индикатора
        indicatorView.frame = CGRect(x: xPosition, y: yPosition, width: indicatorWidth, height: indicatorHeight)
        
        // Анимация изменения позиции индикатора
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.frame = CGRect(x: xPosition, y: yPosition, width: indicatorWidth, height: indicatorHeight)
        }
    }
}
