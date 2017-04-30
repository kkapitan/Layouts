//
//  CircleCell.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 30.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class CircleCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "American Typewriter", size: 20.0)
        label.allowsDefaultTighteningForTruncation = true
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        let views: [IdentifiableView] = [
            ("titleLabel", titleLabel),
        ]
        
        addSubview(containerView)
        
        let layout = LayoutBuilder(views: views)
        views.map { $0.1 }.forEach(containerView.addSubview)
        
        layout.pin(containerView, to: self)
        
        layout.with(format: "V:|-5-[titleLabel]-5-|")
            .activate()
        
        layout.with(format: "H:|-5-[titleLabel]-5-|")
            .activate()
        
        backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2.0
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
