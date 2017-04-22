//
//  AutoresizingCellsViewController.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 22.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit
import Kingfisher

final class AutoresizingViewController: UIViewController, UICollectionViewDataSource {
    
    fileprivate let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.estimatedItemSize = CGSize(width: 200.0, height: 300.0)
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 30.0
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        
        return layout
    }()
    
    
    fileprivate let items: [AutoresizingItem] = {
        return [
            AutoresizingItem(title: "Title 1", description: LoremIpsum.random()),
            AutoresizingItem(title: "Title 2", description: LoremIpsum.random()),
            AutoresizingItem(title: "Title 3", description: LoremIpsum.random()),
            AutoresizingItem(title: "Title 4", description: LoremIpsum.random()),
            AutoresizingItem(title: "Title 5", description: LoremIpsum.random()),
            AutoresizingItem(title: "Title 6", description: LoremIpsum.random()),
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    
        collectionView.registerClass(AutoresizingCell.self)
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
        let cell: AutoresizingCell = collectionView.dequeue(for: indexPath)
        
        let resource = ImageResource(downloadURL: item.imageURL, cacheKey: "Cell-\(indexPath.row)-\(indexPath.section)")
        
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.description
        cell.imageView.kf.setImage(with: resource)
        
        return cell
    }
}



