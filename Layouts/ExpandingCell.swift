//
//  ExpandingCell.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 23.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class ExpandingCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        label.font = UIFont(name: "American Typewriter", size: 20.0)
        
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .asbestos
        return view
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
            ("separatorView", separatorView)
        ]
        
        addSubview(containerView)
        
        let layout = LayoutBuilder(views: views)
        views.map { $0.1 }.forEach(containerView.addSubview)
        
        layout.pin(containerView, to: self)
        
        layout.with(format: "V:|-10-[titleLabel]-9-[separatorView(1)]-0-|")
            .activate()
        
        layout.with(format: "H:|-0-[separatorView]-0-|")
            .activate()
        
        layout.with(format: "H:|-10-[titleLabel]-10-|")
            .activate()
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
