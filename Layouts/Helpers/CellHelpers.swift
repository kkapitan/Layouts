//
//  CellHelpers.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 22.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerClass<T: UITableViewCell>(_ cellClass: T.Type) where T: Reusable {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeue<T: UITableViewCell>() -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Cannot dequeue a cell with identifier \(T.reuseIdentifier)")
        }
        
        return cell
    }
}

extension UICollectionView {
    
    func registerClass<T: UICollectionViewCell>(_ cellClass: T.Type) where T: Reusable {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func registerClass<T: UICollectionReusableView>(_ cellClass: T.Type, forViewOfKind kind: String) where T: Reusable {
        register(cellClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Cannot dequeue a cell with identifier \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeue<T: UICollectionReusableView>(withKind kind: String, for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Cannot dequeue a supplementary with identifier \(T.reuseIdentifier) and kind \(kind)")
        }
        
        return cell
    }
    
}
