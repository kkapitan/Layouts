//
//  CarouselCellFlowLayout.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 22.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class CarouselCellFlowLayout: UICollectionViewFlowLayout {
    var itemScale: CGFloat = 0.5
    var itemAlpha: CGFloat = 0.5
    
    override func prepare() {
        super.prepare()
        
        setupIfNeeded()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        return attributes.map { modify($0) }
    }
    
    private func modify(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = collectionView else { return attributes }
        
        let contentOffset = collectionView.contentOffset.y
        let collectionCenter = collectionView.center.y
        
        let itemCenter = attributes.center.y
        let normalizedItemCenter = itemCenter - contentOffset
        
        let maxDistance = collectionView.center.y
        let distanceFromCenter = min(abs(collectionCenter - normalizedItemCenter), maxDistance)
        
        let ratio = (maxDistance - distanceFromCenter) / maxDistance
        
        let alpha = itemAlpha + ratio * (1.0 - itemAlpha)
        let scale = itemScale + ratio * (1.0 - itemScale)
        let zIndex = Int(ratio * 100)
        
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.alpha = alpha
        attributes.zIndex = zIndex
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private var needsSetup: Bool = true
    
    func setupIfNeeded() {
        guard needsSetup else { return }
        
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        
        guard let collectionView = collectionView else { return }
        
        let estimatedHeight = estimatedItemSize.height
        let inset = (collectionView.frame.height / 2) - estimatedHeight
        
        collectionView.contentInset = UIEdgeInsets(top: inset, left: 0.0, bottom: inset, right: 0.0)
        minimumLineSpacing = -100.0
        
        needsSetup = false
    }
    
    func setSetupNeeded() {
        needsSetup = true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let center = collectionView.center.y
        let proposedOffsetCenterOrigin = center + proposedContentOffset.y
        
        let attributes = layoutAttributesForElements(in: collectionView.bounds)
        let sortedByDistanceToOffset = attributes?.sorted(by: { abs($0.center.y - proposedOffsetCenterOrigin) < abs($1.center.y - proposedOffsetCenterOrigin) })
        
        guard let closest = sortedByDistanceToOffset?.first else { return proposedContentOffset }
        
        return CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - center))
    }
    
}
