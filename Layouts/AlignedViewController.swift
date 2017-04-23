//
//  AlignedViewController.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 23.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

extension AlignedViewController: AlignedLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let random = Int(arc4random()) % 10
        
        return CGSize(width: 100 + 10.0 * CGFloat(random), height: 50.0)
    }
}

final class AlignedViewController: UIViewController, UICollectionViewDataSource {
    
    fileprivate let collectionViewLayout: AlignedLayout = {
        let layout = AlignedLayout()
        return layout
    }()
    
    
    fileprivate let items: [AlignedItem] = {
        return [
            AlignedItem(title: "Title 1"),
            AlignedItem(title: "Title 2"),
            AlignedItem(title: "Title 3"),
            AlignedItem(title: "Title 4"),
            AlignedItem(title: "Title 5"),
            AlignedItem(title: "Title 6"),
            ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.registerClass(AlignedCell.self)
        collectionView.dataSource = self
        
        collectionViewLayout.delegate = self
        collectionView.backgroundColor = .alzarin
        
        view.addSubview(collectionView)
        LayoutBuilder().pin(collectionView, to: view)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = items[indexPath.row]
        let cell: AlignedCell = collectionView.dequeue(for: indexPath)
        
        cell.titleLabel.text = item.title
        
        return cell
    }
}

