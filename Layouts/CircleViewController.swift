//
//  CircleViewController.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 30.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class CircleViewController: UIViewController, UICollectionViewDataSource {
    
    fileprivate let collectionViewLayout: CircleLayout = {
        let layout = CircleLayout()
        
        return layout
    }()
    
    
    fileprivate var items: [CircleItem] = {
        return (1...16).map { CircleItem(title: "\($0)") }
    }()
    
    fileprivate var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        let addBarButtton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        let removeBarButtton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(remove))
        
        navigationItem.rightBarButtonItems = [addBarButtton, removeBarButtton]
    }
    
    fileprivate func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.registerClass(CircleCell.self)
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
        let cell: CircleCell = collectionView.dequeue(for: indexPath)
        
        cell.titleLabel.text = item.title
        
        return cell
    }
    
    func remove() {
        guard items.count > 0 else { return }
        
        let indexPath = IndexPath(item: 0, section: 0)
        items.remove(at: 0)
        
        collectionView.performBatchUpdates({ [weak self] in
            self?.collectionView.deleteItems(at: [indexPath])
        })
    }
    
    func add() {
        let next = (items.flatMap { Int($0.title) }.max() ?? 0) + 1
        let item = CircleItem(title: "\(next)")

        
        items.append(item)
        let indexPath = IndexPath(item: items.count - 1, section: 0)
        collectionView.performBatchUpdates({ [weak self] in
            self?.collectionView.insertItems(at: [indexPath])
        })
    }
}
