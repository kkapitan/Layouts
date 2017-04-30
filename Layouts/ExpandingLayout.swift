//
//  ExpandingLayout.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 23.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class ExpandingLayout: UICollectionViewLayout {
    
    var previous: [UICollectionViewLayoutAttributes] = []
    var attributes: [UICollectionViewLayoutAttributes] = []
    
    var contentSize: CGSize = .zero
    var selectedIndexPath: IndexPath?
    
    override func prepare() {
        super.prepare()
        
        previous = attributes
        contentSize = .zero
        attributes = []
        
        var origin: CGFloat = 0.0
        
        guard let collectionView = collectionView else { return }
        
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let width = collectionView.bounds.width
        
        attributes = (0..<numberOfItems).map { item in
            let indexPath = IndexPath(item: item, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let height: CGFloat = indexPath == selectedIndexPath ? 300.0 : 100.0
            
            let point = CGPoint(x: 0, y: origin)
            let size = CGSize(width: width, height: height)
            
            origin += height
            attribute.frame = CGRect(origin: point, size: size)
            
            return attribute
        }
        
        contentSize = CGSize(width: width, height: origin)
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[indexPath.row]
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[itemIndexPath.row]
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return previous[itemIndexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        
        return collectionView.bounds.size != newBounds.size
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        
        guard let selectedIndexPath = selectedIndexPath else { return proposedContentOffset }
        
        guard let attribute = layoutAttributesForItem(at: selectedIndexPath) else { return proposedContentOffset }
        
        let boundsStart = proposedContentOffset.y
        let boundsEnd = boundsStart + (collectionView?.bounds.height ?? 0.0)
        
        let frame = attribute.frame
        
        if boundsStart > frame.minY && boundsStart < frame.maxY {
            return CGPoint(x: proposedContentOffset.x, y: frame.minY)
        }
        
        if frame.minY < boundsEnd && boundsEnd < frame.maxY {
            return CGPoint(x: proposedContentOffset.x, y: boundsStart + (frame.maxY - boundsEnd))
        }
    
        return proposedContentOffset
    }
}
