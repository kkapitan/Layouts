//
//  CircleLayout.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 30.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class CircleLayout: UICollectionViewLayout {
    
    var circleRadius = CGFloat(160.0)
    var itemSize = CGSize(width: 40.0, height: 40.0)
    
    var previousAttributes: [UICollectionViewLayoutAttributes] = []
    var attributes: [UICollectionViewLayoutAttributes] = []
    
    var circleCenter: CGPoint {
        return CGPoint(x: collectionViewContentSize.width / 2, y: collectionViewContentSize.height / 2)
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        previousAttributes = attributes
        
        attributes = (0..<numberOfItems).map { index in
            let indexPath = IndexPath(item: index, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let angle = CGFloat(index) * (2 * CGFloat.pi / CGFloat(numberOfItems))
            
            let polarX = circleRadius * cos(angle) + circleCenter.x
            let polarY = circleRadius * sin(angle) + circleCenter.y
            
            attribute.size = itemSize
            attribute.center = CGPoint(x: polarX, y: polarY)
            
            return attribute
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[indexPath.row]
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    
        guard insertedIndexPaths.contains(itemIndexPath) else {
            return super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        }
        
        let attributes = self.attributes[itemIndexPath.row]
        
        attributes.alpha = 0.25
        attributes.transform = attributes.transform.scaledBy(x: 0.25, y: 0.25)
        attributes.center = circleCenter
        
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard deletedIndexPaths.contains(itemIndexPath) else {
            return super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        }
        
        let attributes = previousAttributes[itemIndexPath.row]
        
        attributes.alpha = 0.25
        attributes.transform = attributes.transform.scaledBy(x: 0.25, y: 0.25)
        attributes.center = circleCenter
        
        return attributes
    }
    
    var insertedIndexPaths: [IndexPath] = []
    var deletedIndexPaths: [IndexPath] = []
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        insertedIndexPaths = updateItems.filter {$0.updateAction == .insert}.flatMap { $0.indexPathAfterUpdate }
        
        deletedIndexPaths = updateItems.filter {$0.updateAction == .delete}.flatMap { $0.indexPathBeforeUpdate }
    }
    
    override var collectionViewContentSize: CGSize {
        let diameter = 2 * circleRadius
        
        let circleWidth = diameter + itemSize.width
        let circleHeight = diameter + itemSize.height
        
        let width = max(circleWidth, collectionView?.bounds.width ?? 0.0)
        let height = max(circleHeight, (collectionView?.bounds.height ?? 0.0) - 64.0)
        
        return CGSize(width: width, height: height)
    }
}
