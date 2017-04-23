//
//  ExpandingViewController.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 23.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class ExpandingLayout: UICollectionViewLayout {
    
}

final class ExpandingController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate let collectionViewLayout: ExpandingLayout = {
        let layout = ExpandingLayout()
        
        return layout
    }()
    
    
    fileprivate let items: [ExpandingItem] = {
        return [
            ExpandingItem(title: "Title 1"),
            ExpandingItem(title: "Title 2"),
            ExpandingItem(title: "Title 3"),
            ExpandingItem(title: "Title 4"),
            ExpandingItem(title: "Title 5"),
            ExpandingItem(title: "Title 6"),
            ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.registerClass(ExpandingCell.self)
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
        let cell: ExpandingCell = collectionView.dequeue(for: indexPath)
        
        cell.titleLabel.text = item.title

        return cell
    }
}
