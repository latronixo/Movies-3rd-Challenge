//
//  PageControlModel.swift
//  Movies-3rd-Challenge
//
//  Created by Александр Семёнов on 31.03.2025.
//

import UIKit

extension UIImage {
    static func circle(diameter: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    
//    static func roundedRectangle(width: CGFloat, height: CGFloat, cornerRadius: CGFloat) -> UIImage {
//            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
//            let ctx = UIGraphicsGetCurrentContext()!
//            
//            let rect = CGRect(x: 0, y: 0, width: width, height: height)
//            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
//            
//            ctx.addPath(path.cgPath)
//            ctx.fillPath()
//            
//            let img = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
//            
//            return img
//        }
}
