//
//  AlignedLayout.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 23.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import Foundation

import UIKit

protocol AlignedLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}

final class AlignedLayout: UICollectionViewLayout {
    
    var estimatedItemSize: CGSize = CGSize(width: 100, height: 50)
    var itemSpacing: CGFloat = 10.0
    var lineSpacing: CGFloat = 20.0
    var insets: UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var delegate: AlignedLayoutDelegate?
    
    fileprivate var itemAttributes: [UICollectionViewLayoutAttributes] = []
    fileprivate var contentSize: CGSize = .zero
    
    override func prepare() {
        super.prepare()
        
        prepareItemAttributes()
    }
    
    fileprivate func prepareItemAttributes() {
        guard let collectionView = collectionView else { return }
        
        let section = 0
        let numberOfitems = collectionView.numberOfItems(inSection: section)
        let maxLayoutWidth = collectionView.bounds.width
        
        var origin = CGPoint(x: insets.left, y: insets.top)
        var maxHeightInRow = CGFloat(0.0)
        
        itemAttributes = []
        
        for index in (0..<numberOfitems) {
            
            let indexPath = IndexPath(item: index, section: section)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let size = delegate?.collectionView(collectionView, layout: self, sizeForItemAt: indexPath) ?? estimatedItemSize
            let isFittingCurrentLine = origin.x + size.width + insets.right < maxLayoutWidth
            
            origin.x = isFittingCurrentLine ? origin.x : insets.left
            origin.y = isFittingCurrentLine ? origin.y : origin.y + maxHeightInRow + lineSpacing
            
            maxHeightInRow = isFittingCurrentLine ? max(maxHeightInRow, size.height) : size.height
            
            let frame = CGRect(origin: origin, size: size)
            attributes.frame = frame
            
            origin.x += itemSpacing + size.width
            
            itemAttributes.append(attributes)
        }
        
        contentSize = CGSize(width: maxLayoutWidth, height: origin.y)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemAttributes.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.row < itemAttributes.count else { return nil }
        
        return itemAttributes[indexPath.row]
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
}
