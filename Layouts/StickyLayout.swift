//
//  StickyLayout.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 30.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class StickyLayout: UICollectionViewLayout {

    struct SectionLimit {
        let top: CGFloat
        let bottom: CGFloat
    }
    
    // MARK: - Properties
    var previousAttributes: [[UICollectionViewLayoutAttributes]] = []
    var currentAttributes: [[UICollectionViewLayoutAttributes]] = []
    
    var previousSectionAttributes: [UICollectionViewLayoutAttributes] = []
    var currentSectionAttributes: [UICollectionViewLayoutAttributes] = []
    
    var currentSectionLimits: [SectionLimit] = []
    
    var sectionHeaderHeight: CGFloat = 40
    
    var contentSize: CGSize = .zero
    var selectedCellIndexPath: IndexPath?
    
    // MARK: - Preparation
    override func prepare() {
        super.prepare()
        
        prepareContentCellAttributes()
        prepareSectionHeaderAttributes()
    }
    
    private func prepareContentCellAttributes() {
        guard let collectionView = collectionView else { return }
        
        previousAttributes = currentAttributes
        
        contentSize = .zero
        currentAttributes = []
        currentSectionLimits = []
        
        let width = collectionView.bounds.size.width
        var origin: CGFloat = 0
        
        let numberOfSections = collectionView.numberOfSections
        
        (0..<numberOfSections).forEach  { section in
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            
            let top = origin
            
            origin += sectionHeaderHeight
            
            var attributes: [UICollectionViewLayoutAttributes] = []
            (0..<numberOfItems).forEach { index in
                
                let indexPath = IndexPath(item: index, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let height: CGFloat = indexPath == selectedCellIndexPath ? 300.0 : 100.0
                let size = CGSize(width: width, height: height)
                
                attribute.frame = CGRect(x: 0, y: origin, width: width, height: size.height)
                
                attributes.append(attribute)
                
                origin += size.height
            }
            
            let bottom = origin
            let limits = SectionLimit(top: top, bottom: bottom)
            
            currentSectionLimits.append(limits)
            
            currentAttributes.append(attributes)
        }
        
        contentSize = CGSize(width: width, height: origin)
    }
    
    private func prepareSectionHeaderAttributes() {
        guard let collectionView = collectionView else { return }
        
        previousSectionAttributes = currentSectionAttributes
        currentSectionAttributes = []
        
        let width = collectionView.bounds.size.width
        
        let collectionViewTop = collectionView.contentOffset.y
        let aboveCollectionViewTop = collectionViewTop - sectionHeaderHeight
        
        let numberOfSections = collectionView.numberOfSections
        
        currentSectionAttributes = (0..<numberOfSections).map { section in
            let limit = currentSectionLimits[section]
        
            let indexPath = IndexPath(item: 0, section: section)
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: StickyHeader.kind, with: indexPath)
            
            attributes.zIndex = 1
            attributes.frame = CGRect(x: 0, y: limit.top, width: width, height: sectionHeaderHeight)
            
            let sectionTop = limit.top
            let sectionBottom = limit.bottom - sectionHeaderHeight
            
            attributes.frame.origin.y = min(max(sectionTop, collectionViewTop), max(sectionBottom, aboveCollectionViewTop))
            
            return attributes
        }
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return previousAttributes[itemIndexPath.section][itemIndexPath.item]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return currentAttributes[indexPath.section][indexPath.item]
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesForItem(at: itemIndexPath)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let visibleCells = currentAttributes.flatMap { $0 }.filter  { $0.frame.intersects(rect) }
        let visibleHeaders = currentSectionAttributes.filter  { $0.frame.intersects(rect) }
        
        return [visibleCells, visibleHeaders].flatMap { $0 }
    }
    
    override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return previousSectionAttributes[elementIndexPath.section]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return currentSectionAttributes[indexPath.section]
    }
    
    override func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesForSupplementaryView(ofKind: elementKind, at: elementIndexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override class var invalidationContextClass: AnyClass {
        return InvalidationContext.self
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        guard let invalidationContext = super.invalidationContext(forBoundsChange: newBounds) as? InvalidationContext else {
            fatalError("Could not create invalidation context")
        }
        
        guard let oldBounds = collectionView?.bounds else { return invalidationContext }
        guard oldBounds != newBounds else { return invalidationContext }
        
        let originChanged = oldBounds.origin != newBounds.origin
        let sizeChanged = oldBounds.size !=  newBounds.size
        
        invalidationContext.shouldInvalidateEverything = sizeChanged
        invalidationContext.invalidateSectionHeaders = originChanged
    
        return invalidationContext
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if let invalidationContext = context as? InvalidationContext {
            
            if invalidationContext.invalidateSectionHeaders {
                prepareSectionHeaderAttributes()
                
                let allSectionsIndexPaths = currentSectionAttributes.map { $0.indexPath }
                invalidationContext.invalidateSupplementaryElements(ofKind: StickyHeader.kind, at: allSectionsIndexPaths)
            }
        }
        
        super.invalidateLayout(with: context)
    }
    
    // MARK: - Collection View Info
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let selectedCellIndexPath = selectedCellIndexPath else { return proposedContentOffset }
        
        var finalContentOffset = proposedContentOffset
        
        if let frame = layoutAttributesForItem(at: selectedCellIndexPath)?.frame {
            let collectionViewHeight = collectionView?.bounds.size.height ?? 0
            
            let collectionViewTop = proposedContentOffset.y
            let collectionViewBottom = collectionViewTop + collectionViewHeight
            
            let cellTop = frame.origin.y
            let cellBottom = cellTop + frame.size.height
            
            if cellBottom > collectionViewBottom {
                finalContentOffset = CGPoint(x: 0.0, y: collectionViewTop + (cellBottom - collectionViewBottom))
            } else if cellTop < collectionViewTop + sectionHeaderHeight {
                finalContentOffset = CGPoint(x: 0.0, y: collectionViewTop - (collectionViewTop - cellTop) - sectionHeaderHeight)
            }
        }
        
        return finalContentOffset
    }
}

final class InvalidationContext: UICollectionViewLayoutInvalidationContext {
    
    var invalidateSectionHeaders = false
    var shouldInvalidateEverything = true
    
    override var invalidateEverything: Bool {
        return shouldInvalidateEverything
    }
}
