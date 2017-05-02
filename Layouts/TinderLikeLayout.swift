//
//  TinderLikeLayout.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 01.05.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

protocol TinderLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, didMoveItem at: IndexPath, to: TinderLayout.Direction)
}

final class TinderLayout: UICollectionViewLayout {
    
    enum Direction: Int {
        case left, right
    }
    
    enum State {
        case moved(Direction)
        case moving
        case idle
        
        var isMoving: Bool {
            switch self {
            case .moving:
                return true
            default:
                return false
            }
        }
    }
    
    var delegate: TinderLayoutDelegate?
    
    var cellAttributes: [UICollectionViewLayoutAttributes] = []
    var decorationAttributes: [UICollectionViewLayoutAttributes] = []
    
    var maxVisibleItems = 5
    
    var itemSize = CGSize(width: 280, height: 280)
    var interItemTopOffset: CGFloat = 10.0
    
    override func prepare() {
        super.prepare()
        setupIfNeeded()
        
        setupCellAttributes()
        setupDecorationAttributes()
    }
    
    fileprivate func setupCellAttributes() {
        guard let collectionView = collectionView else { return }
        
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        let centerX = collectionView.bounds.midX
        let centerY = collectionView.bounds.midY
        
        cellAttributes = (0..<numberOfItems).map { index in
            
            let indexPath = IndexPath(item: index, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attribute.size = itemSize
            
            let x = centerX
            let y = centerY - interItemTopOffset * CGFloat(min(index, maxVisibleItems - 1))
            
            let shouldApplyOffset = indexPath.row == 0 && state.isMoving
            
            let offsetX = shouldApplyOffset ? movedOffset.x : x
            let offsetY = shouldApplyOffset ? movedOffset.y : y
            
            attribute.center = CGPoint(x: offsetX, y: offsetY)
            attribute.zIndex = -index
            
            return attribute
        }
    }
    
    fileprivate func setupDecorationAttributes() {
        guard let collectionView = collectionView else { return }
        
        let size = CGSize(width: 150.0, height: 150.0)
        
        let centerX = collectionView.bounds.midX
        let centerY = collectionView.bounds.midY
        
        let acceptIndexPath = IndexPath(item: 1, section: 0)
        let acceptAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: AcceptView.kind, with: acceptIndexPath)
        
        let declineIndexPath = IndexPath(item: 0, section: 0)
        let declineAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: DeclineView.kind, with: declineIndexPath)
        
        let shouldApplyOffset = state.isMoving
        
        let x = shouldApplyOffset ? movedOffset.x : centerX
        let y = shouldApplyOffset ? movedOffset.y : centerY
        
        acceptAttributes.center = CGPoint(x: x, y: y)
        declineAttributes.center = CGPoint(x: x, y: y)
        
        acceptAttributes.zIndex = 100
        declineAttributes.zIndex = 100
        
        acceptAttributes.alpha = min(max(0, (x - centerX)/centerX), 1)
        declineAttributes.alpha = min(max(0, (centerX - x)/centerX), 1)
        
        acceptAttributes.size = size
        declineAttributes.size = size
        
        decorationAttributes = [acceptAttributes, declineAttributes]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return [cellAttributes, decorationAttributes].flatMap { $0 }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributes[indexPath.row]
    }
    
    fileprivate var deletedIndexPaths: [IndexPath] = []
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        deletedIndexPaths = updateItems
            .filter { $0.updateAction == .delete }
            .flatMap { $0.indexPathBeforeUpdate }
    }

    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let baseAttributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        
        guard let collectionView = collectionView else { return baseAttributes }
        
        if deletedIndexPaths.contains(itemIndexPath) {
            if case .moved(let direction) = state {
                baseAttributes?.center.x = direction == .left ? -300.0 : collectionView.bounds.width + 300.0
            }
        }
        baseAttributes?.alpha = 1.0
        return baseAttributes
    }
//    
//    override func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let baseAttributes = super.finalLayoutAttributesForDisappearingDecorationElement(ofKind: elementKind, at: decorationIndexPath)
//        baseAttributes?.alpha = 0.0
//        baseAttributes?.center = movedOffset
//        return baseAttributes
//    }
//    
//    override func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let baseAttributes = super.initialLayoutAttributesForAppearingDecorationElement(ofKind: elementKind, at: decorationIndexPath)
//        baseAttributes?.alpha = 0.0
//        baseAttributes?.center = movedOffset
//        return baseAttributes
//    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return decorationAttributes
            .filter {
                $0.indexPath == indexPath
            }.filter {
                $0.representedElementKind == elementKind
            }.first
    }
    
    fileprivate var state: State = .idle
    fileprivate var movedOffset: CGPoint = .zero
    
    func handlePan(pan: UIPanGestureRecognizer) {
        
        switch pan.state {
        case .began:
            
            let point = pan.location(in: collectionView)
            let indexPath = collectionView?.indexPathForItem(at: point)
            state = indexPath?.row == 0 ? .moving : .idle
            
            fallthrough
        case .changed:
            guard state.isMoving else { return }
            
            movedOffset = pan.location(in: collectionView)
            invalidateLayout()
            
        default:
            guard state.isMoving else { return }
            
            state = .idle
            notifyIfNeeded()
            
            UIView.animate(withDuration: 1.0, animations: {
                self.invalidateLayout()
            })
        }
        
    }
    
    
    fileprivate var contentSize: CGSize = .zero
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    fileprivate var needsSetup: Bool = true
    fileprivate func setupIfNeeded() {
        guard needsSetup else { return }
        
        guard let collectionView = collectionView else { return }
        
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height + collectionView.contentOffset.y
        
        contentSize = CGSize(width: width, height: height)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        collectionView.addGestureRecognizer(panGestureRecognizer)
        
        registerDecorationView()
        
        needsSetup = false
    }
    
    fileprivate func notifyIfNeeded() {
        guard let collectionView = collectionView else { return }
        
        let threshold: CGFloat = 50.0
        
        let indexPath = IndexPath(item: 0, section: 0)
        let offsetX = movedOffset.x
        
        if offsetX > collectionView.bounds.width - threshold {
            print("Moved right!")
            state = .moved(.right)
            delegate?.collectionView(collectionView, didMoveItem: indexPath, to: .right)
            
        } else if offsetX < threshold {
            print("Moved left!")
            state = .moved(.left)
            delegate?.collectionView(collectionView, didMoveItem: indexPath, to: .left)
        }
    }
    
    fileprivate func registerDecorationView() {
        register(AcceptView.self, forDecorationViewOfKind: AcceptView.kind)
        register(DeclineView.self, forDecorationViewOfKind: DeclineView.kind)
    }
}

final class AcceptView: UICollectionReusableView {
    static let kind = "AcceptViewKind"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class DeclineView: UICollectionReusableView {
    static let kind = "DeclineViewKind"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
