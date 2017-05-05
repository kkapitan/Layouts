//
//  ArcLayout.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 30.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class ArcLayout: UICollectionViewLayout {

    var itemSize = CGSize(width: 130, height: 170)
    var radius: CGFloat = 500
    
    var anglePerItem: CGFloat {
        return atan(itemSize.width / radius)
    }
    
    var attributes: [ArcAttributes] = []
    
    var angleOffset: CGFloat {
        
        guard let collectionView = collectionView else { return 0.0 }
        
        let offsetX = collectionView.contentOffset.x
        let maxOffsetX = collectionViewContentSize.width - collectionView.bounds.width
        
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let maxAngle = -1 * CGFloat(numberOfItems - 1) * anglePerItem
        
        return maxAngle * offsetX / maxOffsetX
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        
        let numberOfItems = CGFloat(collectionView.numberOfItems(inSection: 0))
        
        return CGSize(width: numberOfItems * itemSize.width, height: collectionView.bounds.height - 64)
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let centerY = collectionView.bounds.midY
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2.0
        
        let anchorY = ((itemSize.height/2.0) + radius)/itemSize.height
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        
        attributes = (0..<numberOfItems).map { index in
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = ArcAttributes(forCellWith: indexPath)
            
            
            attributes.size = itemSize
            attributes.center = CGPoint(x: centerX, y: centerY)
            
            attributes.anchorPoint = CGPoint(x: 0.5, y: 0.5 + radius/itemSize.height)
            attributes.angle = angleOffset + CGFloat(index) * anglePerItem
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorY)
            
            print(collectionView.contentOffset.x)
            print(angleOffset)
            
            return attributes
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override class var layoutAttributesClass: AnyClass {
        return ArcAttributes.self
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attributes
        //return attributes.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
       return attributes[indexPath.row]
    }
}

final class ArcAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    var angle: CGFloat = 0 {
        didSet {
            zIndex = Int(angle * 1000000)
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copied = super.copy(with: zone) as! ArcAttributes
        
        copied.anchorPoint = anchorPoint
        copied.angle = angle
        
        return copied
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let attributes = object as? ArcAttributes else { return false }
        
        return super.isEqual(attributes) && attributes.angle == angle &&  anchorPoint == attributes.anchorPoint
    }
    
}
