//
//  TinderLikeLayout.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 01.05.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class TinderLayout: UICollectionViewLayout {
    
    var attributes: [UICollectionViewLayoutAttributes] = []
    var maxVisibleItems = 5
    
    var itemSize = CGSize(width: 280, height: 280)
    var interItemTopOffset: CGFloat = 10.0
    
    override func prepare() {
        super.prepare()
        setupIfNeeded()
        
        guard let collectionView = collectionView else { return }
        
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let numberOfVisibleItems = min(numberOfItems, maxVisibleItems)
        
        let centerX = collectionView.bounds.midX
        let centerY = collectionView.bounds.midY
        
        attributes = (0..<numberOfVisibleItems).map { index in
            
            let indexPath = IndexPath(item: index, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attribute.size = itemSize
            attribute.center = CGPoint(x: centerX, y: centerY - interItemTopOffset * CGFloat(index))
            attribute.zIndex = -index
            
            return attribute
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[indexPath.row]
    }
    
    fileprivate var contentSize: CGSize = .zero
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    fileprivate var needsSetup: Bool = true
    func setupIfNeeded() {
        guard needsSetup else { return }
        
        guard let collectionView = collectionView else { return }
        
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height + collectionView.contentOffset.y
        
        contentSize = CGSize(width: width, height: height)
        
        needsSetup = false
    }
}
