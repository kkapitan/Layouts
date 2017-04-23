//
//  FixedVerticalCarouselController.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 22.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit
import Kingfisher

final class FixedVerticalCarouselController: UIViewController, UICollectionViewDataSource {
    
    fileprivate let collectionViewLayout: FixedVerticalCarouselFlowLayout = {
        let layout = FixedVerticalCarouselFlowLayout()
        
        let screenSize = UIScreen.main.bounds.size
        let ratio: CGFloat = 0.8
        
        layout.itemSize = CGSize(width: ratio * screenSize.width, height: ratio * screenSize.height)
        
        layout.scrollDirection = .horizontal
        
        layout.minimumInteritemSpacing = ratio
        
        return layout
    }()
    
    
    fileprivate let items: [FixedVerticalCarouselItem] = {
        return [
            FixedVerticalCarouselItem(title: "Title 1", description: LoremIpsum.random()),
            FixedVerticalCarouselItem(title: "Title 2", description: LoremIpsum.random()),
            FixedVerticalCarouselItem(title: "Title 3", description: LoremIpsum.random()),
            FixedVerticalCarouselItem(title: "Title 4", description: LoremIpsum.random()),
            FixedVerticalCarouselItem(title: "Title 5", description: LoremIpsum.random()),
            FixedVerticalCarouselItem(title: "Title 6", description: LoremIpsum.random()),
            ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.registerClass(FixedVerticalCarouselCell.self)
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
        let cell: FixedVerticalCarouselCell = collectionView.dequeue(for: indexPath)
        
        let resource = ImageResource(downloadURL: item.imageURL, cacheKey: "Cell-\(indexPath.row)-\(indexPath.section)")
        
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.description
        cell.imageView.kf.setImage(with: resource)
        
        return cell
    }
}

