//
//  FixedVerticalCarouselLayout.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 22.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class FixedVerticalCarouselFlowLayout: UICollectionViewFlowLayout {
    var itemScale: CGFloat = 0.75
    var itemAlpha: CGFloat = 0.75
    
    override func prepare() {
        super.prepare()
        
        setupIfNeeded()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        return attributes.map { modify($0) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let  attributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
        return modify(attributes)
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else { return nil }
        return modify(attributes)
    }
    
    private func modify(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = collectionView else { return attributes }
        
        let center = collectionView.center.x
        let itemCenter = attributes.center.x
        
        let normalizedCenter = itemCenter - collectionView.contentOffset.x
        let maxDistance = itemSize.width
        
        let distance = min(abs(normalizedCenter - center), maxDistance)
        let ratio = (maxDistance - distance)/maxDistance
        
        let scale = itemScale + (1 - itemScale) * ratio
        let alpha = itemAlpha + (1 - itemAlpha) * ratio
        
        attributes.alpha = alpha
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1.0)
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private var needsSetup: Bool = true
    
    func setupIfNeeded() {
        guard needsSetup else { return }
        
        guard let collectionView = collectionView else { return }
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
            
        let center = collectionView.frame.width / 2
        let itemCenter = itemSize.width / 2
        
        let inset = center - itemCenter
        
        sectionInset = UIEdgeInsets(top: 0.0, left: inset, bottom: 0.0, right: inset)
        
        needsSetup = false
    }
    
    func setSetupNeeded() {
        needsSetup = true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let center = collectionView.center.x
        let proposedOffsetCenterOrigin = center + proposedContentOffset.x
        
        let attributes = layoutAttributesForElements(in: collectionView.bounds)
        let sortedByDistanceToOffset = attributes?.sorted(by: { abs($0.center.x - proposedOffsetCenterOrigin) < abs($1.center.x - proposedOffsetCenterOrigin) })
        
        guard let closest = sortedByDistanceToOffset?.first else { return proposedContentOffset }
        
        return CGPoint(x: floor(closest.center.x - center), y: proposedContentOffset.y)
    }
    
}
