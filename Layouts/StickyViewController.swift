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
    
    fileprivate let items: [[StickyItem]] = {
        return [
            [
                StickyItem(title: "Title 1"),
                StickyItem(title: "Title 2"),
                StickyItem(title: "Title 3"),
                StickyItem(title: "Title 4"),
                StickyItem(title: "Title 5"),
                StickyItem(title: "Title 6"),
            ],
            [
                StickyItem(title: "Title 1"),
                StickyItem(title: "Title 2"),
                StickyItem(title: "Title 3"),
                StickyItem(title: "Title 4"),
                StickyItem(title: "Title 5"),
                StickyItem(title: "Title 6"),
            ],
            [
                StickyItem(title: "Title 1"),
                StickyItem(title: "Title 2"),
                StickyItem(title: "Title 3"),
                StickyItem(title: "Title 4"),
                StickyItem(title: "Title 5"),
                StickyItem(title: "Title 6"),
            ],
            [
                StickyItem(title: "Title 1"),
                StickyItem(title: "Title 2"),
                StickyItem(title: "Title 3"),
                StickyItem(title: "Title 4"),
                StickyItem(title: "Title 5"),
                StickyItem(title: "Title 6"),
            ]
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
        collectionView.registerClass(StickyHeader.self, forViewOfKind: StickyHeader.kind)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .alzarin
        collectionView.alwaysBounceVertical = true
        
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(collectionView)
        LayoutBuilder().pin(collectionView, to: view, edges: UIEdgeInsets(top: 64.0, left: 0.0, bottom: 0.0, right: 0.0))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = items[indexPath.section][indexPath.row]
        let cell: StickyCell = collectionView.dequeue(for: indexPath)
        
        cell.titleLabel.text = item.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: StickyHeader = collectionView.dequeue(withKind: kind, for: indexPath)
        header.title = "Section \(indexPath.section + 1)"
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionViewLayout.selectedCellIndexPath = collectionViewLayout.selectedCellIndexPath == indexPath ? nil : indexPath
        
        UIView.animate(withDuration: 0.5) {
            self.collectionViewLayout.invalidateLayout()
            self.collectionViewLayout.collectionView?.layoutIfNeeded()
        }
    }
}
