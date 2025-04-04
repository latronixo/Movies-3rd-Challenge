//
//  PageControlModel.swift
//  Movies-3rd-Challenge
//
//  Created by Александр Семёнов on 31.03.2025.
//
import UIKit

// Расширение для класса UIImage для добавления дополнительных функций
extension UIImage {
    // Создает изображение скругленного прямоугольника заданного размера и цвета
    // - Parameters:
    //   - width: Ширина изображения
    //   - height: Высота изображения
    //   - cornerRadius: Радиус скругления углов
    //   - color: Цвет заливки прямоугольника
    static func roundedRectangle(width: CGFloat, height: CGFloat, cornerRadius: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        ctx.setFillColor(color.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
        
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
}
