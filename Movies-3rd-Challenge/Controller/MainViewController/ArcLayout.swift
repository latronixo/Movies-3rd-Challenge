//
//  ArcLayout.swift
//  Movies-3rd-Challenge
//
//  Created by Anna Melekhina on 01.04.2025.
//

import UIKit

final class ArcLayout: UICollectionViewLayout {

    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        private var itemCount: Int = 0

         let itemSize = CGSize(width: 180, height: 240)
    // Радиус окружности
        private let radius: CGFloat = 480
    // Расстояние между ячейками
        let anglePerItem: CGFloat = .pi / 13

    //точка привязки коллекции
    private var anchorPointY: CGFloat {
        return ((itemSize.height / 2.0) + radius) / itemSize.height
    }

    private var center: CGPoint = .zero
        private var contentWidth: CGFloat = 0
    
    var angleAtExtreme: CGFloat {
        let itemCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        return itemCount > 0 ? -CGFloat(itemCount - 1) * anglePerItem : 0
    }
    
    var angle: CGFloat {
        guard let cv = collectionView else { return 0 }
        let maxOffsetX = collectionViewContentSize.width - cv.bounds.width
        return angleAtExtreme * cv.contentOffset.x / maxOffsetX
    }


        override var collectionViewContentSize: CGSize {
            guard let cv = collectionView else { return .zero }
            return CGSize(width: contentWidth, height: cv.bounds.height)
        }

    override func prepare() {
        super.prepare()
        guard let cv = collectionView else { return }

        itemCount = cv.numberOfItems(inSection: 0)
        layoutAttributes = []

        for item in 0..<itemCount {
            let indexPath = IndexPath(item: item, section: 0)
            if let attributes = layoutAttributesForItem(at: indexPath) {
                layoutAttributes.append(attributes)
            }
        }

        contentWidth = CGFloat(itemCount) * (itemSize.width + 20)
    }

        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            layoutAttributes.map { layoutAttributesForItem(at: $0.indexPath)! }
        }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let cv = collectionView else { return nil }

        let attributes = CircularCollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = itemSize
        attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)


        let itemAngle = angle + anglePerItem * CGFloat(indexPath.item)

        // Центр окружности
        let center = CGPoint(x: cv.bounds.midX, y: cv.bounds.midY)

        // Положение по дуге
        let x = center.x + sin(itemAngle) * radius
        let y = center.y - cos(itemAngle) * radius + 500
        attributes.center = CGPoint(x: x, y: y)

        // Вращение по касательной
        attributes.transform3D = CATransform3DMakeRotation(itemAngle, 0, 0, 1)
        attributes.zIndex = Int(1000 - abs(itemAngle * 1000))

        return attributes
    }


        override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return true
        }
    }

class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)

    var angle: CGFloat = 0 {
        didSet {
            zIndex = Int(angle * 1_000_000)
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
        copy.anchorPoint = self.anchorPoint
        copy.angle = self.angle
        return copy
    }
}

