//
//  StickyViewController.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 30.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import Foundation

import UIKit

final class StickyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate let collectionViewLayout: StickyLayout = {
        let layout = StickyLayout()
        
        return layout
    }()
    
    fileprivate let items: [StickyItem] = {
        return [
            StickyItem(title: "Title 1"),
            StickyItem(title: "Title 2"),
            StickyItem(title: "Title 3"),
            StickyItem(title: "Title 4"),
            StickyItem(title: "Title 5"),
            StickyItem(title: "Title 6"),
            ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.registerClass(StickyCell.self)
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
        let cell: StickyCell = collectionView.dequeue(for: indexPath)
        
        cell.titleLabel.text = item.title
        
        return cell
    }
}
