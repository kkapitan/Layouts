//
//  CarouselCollectionView.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 22.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit
import Kingfisher

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
        
        if (attributes.indexPath.row == 2) {
            print(attributes.indexPath.row)
            print(distanceFromCenter)
            print(ratio)
            print(alpha)
        }
        
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
        
        guard let collectionView = collectionView else { return }
        
        print(collectionView.frame)
        
        let estimatedHeight = estimatedItemSize.height
        let inset = (collectionView.frame.height / 2) - estimatedHeight
        
        collectionView.contentInset = UIEdgeInsets(top: inset, left: 0.0, bottom: inset, right: 0.0)
        minimumLineSpacing = -100.0
        
        needsSetup = false
    }
    
    func setSetupNeeded() {
        needsSetup = true
    }
}

final class CarouselViewController: UIViewController, UICollectionViewDataSource {
    
    fileprivate let collectionViewLayout: CarouselCellFlowLayout = {
        let layout = CarouselCellFlowLayout()
        
        layout.estimatedItemSize = CGSize(width: 200.0 * layout.itemScale, height: 300.0 * layout.itemScale)
        layout.minimumLineSpacing = 10.0
        
        return layout
    }()
    
    
    fileprivate let items: [CarouselItem] = {
        return [
            CarouselItem(title: "Title 1", description: LoremIpsum.random()),
            CarouselItem(title: "Title 2", description: LoremIpsum.random()),
            CarouselItem(title: "Title 3", description: LoremIpsum.random()),
            CarouselItem(title: "Title 4", description: LoremIpsum.random()),
            CarouselItem(title: "Title 5", description: LoremIpsum.random()),
            CarouselItem(title: "Title 6", description: LoremIpsum.random()),
            ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.registerClass(CarouselCell.self)
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .alzarin
    
        view.addSubview(collectionView)
        LayoutBuilder().pin(collectionView, to: view)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = items[indexPath.row]
        let cell: CarouselCell = collectionView.dequeue(for: indexPath)
        
        let resource = ImageResource(downloadURL: item.imageURL, cacheKey: "Cell-\(indexPath.row)-\(indexPath.section)")
        
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.description
        cell.imageView.kf.setImage(with: resource)
        
        return cell
    }
}



