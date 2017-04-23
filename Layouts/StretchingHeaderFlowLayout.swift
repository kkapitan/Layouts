//
//  StretchingHeaderFlowLayout.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 23.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class StretchingHeaderLayoutAttributes: UICollectionViewLayoutAttributes {
    var delta: CGFloat?
    
    override func copy(with zone: NSZone? = nil) -> Any {
        guard let copy = super.copy(with: zone) as? StretchingHeaderLayoutAttributes else {
            fatalError("Unable to copy attributes")
        }
        
        copy.delta = delta
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let attributes = object as? StretchingHeaderLayoutAttributes else { return false }
        
        return attributes.delta == delta && super.isEqual(object)
    }
}

final class StretchingHeaderLayout : UICollectionViewFlowLayout {
    
    var maximumStretchHeight: CGFloat?
    
    override class var layoutAttributesClass: AnyClass {
        return StretchingHeaderLayoutAttributes.self
    }
    
    override func prepare() {
        super.prepare()
        setupIfNeeded()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        return attributes?.map {
            $0.representedElementKind == UICollectionElementKindSectionHeader ? modifyHeader($0) : $0
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func modifyHeader(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = collectionView else { return attributes }
        
        guard let headerAttributes = attributes as? StretchingHeaderLayoutAttributes else { return attributes }
        
        var frame = headerAttributes.frame
        
        let stretchingLimit = self.maximumStretchHeight ?? collectionView.bounds.width
        let maxDelta = stretchingLimit - frame.height
        
        let delta = min(maxDelta, max(0, baseOffset - collectionView.contentOffset.y))
        let newHeight = frame.height + delta
        
        frame.origin.y -= delta
        frame.size.height = newHeight
        
        headerAttributes.frame = frame
        headerAttributes.delta = delta
        
        return headerAttributes
    }
    
    private var needsSetup: Bool = true
    private var baseOffset: CGFloat = 0.0
    
    func setupIfNeeded() {
        guard needsSetup else { return }
        
        guard let collectionView = collectionView else { return }
        
        baseOffset = collectionView.contentOffset.y
        needsSetup = false
    }
    
    func setSetupNeeded() {
        needsSetup = true
    }
}
