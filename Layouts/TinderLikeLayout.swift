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
        
        acceptAttributes.isHidden = !state.isMoving
        
        acceptAttributes.center = CGPoint(x: x, y: y)
        declineAttributes.center = CGPoint(x: x, y: y)
        
        acceptAttributes.zIndex = 100
        declineAttributes.zIndex = 100
        
        acceptAttributes.alpha = min(max(0, (x - centerX)/centerX), 1)
        declineAttributes.alpha = min(max(0, (centerX - x)/centerX), 1)
        
        acceptAttributes.size = size
        declineAttributes.size = size
        print("Setup View \(acceptAttributes.representedElementKind)")
        decorationAttributes = [acceptAttributes, declineAttributes]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if state.isMoving {
            return [cellAttributes, decorationAttributes].flatMap { $0 }
        }
        
        return cellAttributes
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
    
    fileprivate let offscreenOffset: CGFloat = 300.0
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let baseAttributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        
        guard let collectionView = collectionView else { return baseAttributes }
        
        if deletedIndexPaths.contains(itemIndexPath) {
            if case .moved(let direction) = state {
                baseAttributes?.center.x = direction == .left ? -offscreenOffset : collectionView.bounds.width + offscreenOffset
            }
        }
        
        baseAttributes?.alpha = 1.0
        return baseAttributes
    }
    
    
    override func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let baseAttributes = decorationAttributes
            .filter {
                $0.indexPath == decorationIndexPath
            }.filter {
                $0.representedElementKind == elementKind
            }.first
        
        guard let collectionView = collectionView else { return baseAttributes }
        
        if case .moved(let direction) = state {
            baseAttributes?.center.x = direction == .left ? -offscreenOffset : collectionView.bounds.width + offscreenOffset
        }

        return baseAttributes
    }
    
    
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
            moveIfNeeded()
            
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
    
    fileprivate func moveIfNeeded() {
        guard let collectionView = collectionView else { return }
        
        let threshold: CGFloat = 50.0
        let offsetX = movedOffset.x
        
        if offsetX > collectionView.bounds.width - threshold {
            move(.right)
        } else if offsetX < threshold {
            move(.left)
        }
    }
    
    func move(_ direction: Direction, animated: Bool = false) {
        guard let collectionView = collectionView else { return }
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        state = .moved(direction)
        delegate?.collectionView(collectionView, didMoveItem: indexPath, to: direction)
        
        if animated {
            UIView.animate(withDuration: 1.0) {
                self.invalidateLayout()
            }
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
        
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let lineWidth = CGFloat(5.0)
        UIColor.green.withAlphaComponent(0.8).setStroke()
        
        let frame = rect.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
        
        let path = UIBezierPath.heartIn(frame)
        path.lineWidth = lineWidth
        path.stroke()
        
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height))

        ovalPath.lineWidth = lineWidth
        ovalPath.stroke()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class DeclineView: UICollectionReusableView {
    static let kind = "DeclineViewKind"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let lineWidth = CGFloat(5.0)
        UIColor.red.withAlphaComponent(0.8).setStroke()
        
        let rect = rect.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
        
        let border = UIBezierPath(ovalIn: rect)
        border.lineWidth = lineWidth
        border.stroke()
        
        let path = UIBezierPath.crossIn(rect)
        path.lineWidth = 2 * lineWidth
        path.stroke()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIImage {
    static func heart(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let initial = CGRect(origin: .zero, size: size)
        
        let lineWidth = CGFloat(2.0)
        UIColor.green.setStroke()
        
        let frame = initial.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
        
        let path = UIBezierPath.heartIn(frame)
        path.lineWidth = lineWidth
        path.stroke()
        
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height))
        
        ovalPath.lineWidth = lineWidth
        ovalPath.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image
    }
    
    static func cross(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let initial = CGRect(origin: .zero, size: size)
        

        let lineWidth = CGFloat(2.0)
        UIColor.red.setStroke()
        
        let rect = initial.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
        
        let border = UIBezierPath(ovalIn: rect)
        border.lineWidth = lineWidth
        border.stroke()
        
        let path = UIBezierPath.crossIn(rect)
        path.lineWidth = 2*lineWidth
        path.stroke()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIBezierPath {
    
    static func crossIn(_ rect: CGRect) -> UIBezierPath {
        
        let radius = rect.width / 2.0
        let path = UIBezierPath()
        
        for i in [1,3,5,7] {
            
            let x = radius * cos(CGFloat(i) * CGFloat.pi/4.0) + rect.midX
            let y = radius * sin(CGFloat(i) * CGFloat.pi/4.0) + rect.midY
            
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
    
    static func heartIn(_ rect: CGRect) -> UIBezierPath {
        
        
        let frame = rect
        
        let heartPath = UIBezierPath()
        heartPath.move(to: CGPoint(x: frame.minX + 0.46677 * frame.width, y: frame.minY + 0.91183 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.36700 * frame.width, y: frame.minY + 0.81724 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.44879 * frame.width, y: frame.minY + 0.88999 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.40389 * frame.width, y: frame.minY + 0.84743 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.19842 * frame.width, y: frame.minY + 0.67055 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.25768 * frame.width, y: frame.minY + 0.72778 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.24280 * frame.width, y: frame.minY + 0.71484 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.08261 * frame.width, y: frame.minY + 0.39427 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.11659 * frame.width, y: frame.minY + 0.58891 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.08249 * frame.width, y: frame.minY + 0.50491 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.09947 * frame.width, y: frame.minY + 0.28846 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.08267 * frame.width, y: frame.minY + 0.34026 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.08544 * frame.width, y: frame.minY + 0.32046 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.20317 * frame.width, y: frame.minY + 0.16914 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.12327 * frame.width, y: frame.minY + 0.23416 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.15834 * frame.width, y: frame.minY + 0.19382 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.30426 * frame.width, y: frame.minY + 0.14766 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.23493 * frame.width, y: frame.minY + 0.15167 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.25123 * frame.width, y: frame.minY + 0.14798 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.40339 * frame.width, y: frame.minY + 0.16968 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.35973 * frame.width, y: frame.minY + 0.14733 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.37076 * frame.width, y: frame.minY + 0.15026 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.49243 * frame.width, y: frame.minY + 0.27974 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.44310 * frame.width, y: frame.minY + 0.19333 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.48398 * frame.width, y: frame.minY + 0.24385 * frame.height))
        heartPath.addLine(to: CGPoint(x: frame.minX + 0.49765 * frame.width, y: frame.minY + 0.30191 * frame.height))
        heartPath.addLine(to: CGPoint(x: frame.minX + 0.51052 * frame.width, y: frame.minY + 0.27138 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.65796 * frame.width, y: frame.minY + 0.14744 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.54018 * frame.width, y: frame.minY + 0.20103 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.59635 * frame.width, y: frame.minY + 0.15979 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.89625 * frame.width, y: frame.minY + 0.27567 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.74745 * frame.width, y: frame.minY + 0.12950 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.84840 * frame.width, y: frame.minY + 0.17248 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.90197 * frame.width, y: frame.minY + 0.51544 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.92189 * frame.width, y: frame.minY + 0.33094 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.92470 * frame.width, y: frame.minY + 0.44896 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.68789 * frame.width, y: frame.minY + 0.76958 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.87232 * frame.width, y: frame.minY + 0.60216 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.81663 * frame.width, y: frame.minY + 0.66827 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.50124 * frame.width, y: frame.minY + 0.95067 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.60345 * frame.width, y: frame.minY + 0.83602 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.50790 * frame.width, y: frame.minY + 0.93655 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.46677 * frame.width, y: frame.minY + 0.91183 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.49352 * frame.width, y: frame.minY + 0.96706 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.50088 * frame.width, y: frame.minY + 0.95324 * frame.height))
        heartPath.close()
        
        
        heartPath.miterLimit = 4
    
        return heartPath
    }
}
