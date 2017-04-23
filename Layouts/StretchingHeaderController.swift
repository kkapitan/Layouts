//
//  StretchingHeaderController.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 23.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit
import Kingfisher

final class StretchingHeaderController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate let collectionViewLayout: StretchingHeaderLayout = {
        let layout = StretchingHeaderLayout()
        
        let screenSize = UIScreen.main.bounds.size
        
        layout.itemSize = CGSize(width: screenSize.width, height: 70)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.0
        layout.headerReferenceSize = CGSize(width: screenSize.width, height: 200.0)
        
        return layout
    }()
    
    
    fileprivate let items: [StretchingHeaderItem] = {
        return [
            StretchingHeaderItem(title: "Title 1"),
            StretchingHeaderItem(title: "Title 2"),
            StretchingHeaderItem(title: "Title 3"),
            StretchingHeaderItem(title: "Title 4"),
            StretchingHeaderItem(title: "Title 5"),
            StretchingHeaderItem(title: "Title 6"),
            StretchingHeaderItem(title: "Title 1"),
            StretchingHeaderItem(title: "Title 2"),
            StretchingHeaderItem(title: "Title 3"),
            StretchingHeaderItem(title: "Title 4"),
            StretchingHeaderItem(title: "Title 5"),
            StretchingHeaderItem(title: "Title 6"),
            StretchingHeaderItem(title: "Title 1"),
            StretchingHeaderItem(title: "Title 2"),
            StretchingHeaderItem(title: "Title 3"),
            StretchingHeaderItem(title: "Title 4"),
            StretchingHeaderItem(title: "Title 5"),
            StretchingHeaderItem(title: "Title 6"),
            ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.registerClass(StretchingHeaderCell.self)
        collectionView.registerClass(StretchingHeaderView.self, forViewOfKind: UICollectionElementKindSectionHeader)
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .alzarin
        collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)
        LayoutBuilder().pin(collectionView, to: view)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = items[indexPath.row]
        let cell: StretchingHeaderCell = collectionView.dequeue(for: indexPath)
        
        let resource = ImageResource(downloadURL: item.imageURL, cacheKey: "Cell-\(indexPath.row)-\(indexPath.section)")
        
        cell.titleLabel.text = item.title
        cell.imageView.kf.setImage(with: resource)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header: StretchingHeaderView = collectionView.dequeue(withKind: kind, for: indexPath)
            
            let backImageURL = URL(string: "https://unsplash.it/600/600/?random")
            
            let random = 1 + Int(arc4random()) % 50
            let frontImageURL = URL(string: "https://randomuser.me/api/portraits/women/\(random).jpg")
            
            header.backImageView.kf.setImage(with: backImageURL)
            header.frontImageView.kf.setImage(with: frontImageURL)

            return header
        default:
            fatalError("\(kind) is not supported")
        }
    }
}

