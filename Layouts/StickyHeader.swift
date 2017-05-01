//
//  StickyHeader.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 30.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class StickyHeader: UICollectionReusableView {
    
    class var kind: String { return "SectionHeaderCell" }
    
    fileprivate let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var title: String? {
        didSet {
            label.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.2, alpha: 1.0)

        
        let views: [IdentifiableView] = [
            ("label", label),
        ]
        
        let layout = LayoutBuilder(views: views)
        views.map { $0.1 }.forEach(addSubview)
        
        layout.with(format: "H:|-20-[label]-20-|").activate()
        layout.with(format: "V:|-0-[label]-0-|").activate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: Layout
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        layoutIfNeeded()
    }
}
