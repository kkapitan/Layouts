//
//  CarouselCell.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 22.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class CarouselCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        label.font = UIFont(name: "American Typewriter", size: 14.0)
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "American Typewriter", size: 12.0)
        
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
        
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
            ("imageView", imageView),
            ("titleLabel", titleLabel),
            ("descriptionLabel", descriptionLabel)
        ]
        
        addSubview(containerView)
        
        let layout = LayoutBuilder(views: views)
        views.map { $0.1 }.forEach(containerView.addSubview)
        
        layout.pin(containerView, to: self)
        
        layout.with(format: "V:|-0-[imageView(200)]-10-[titleLabel]-10-[descriptionLabel]-10-|")
            .activate()
        
        layout.with(format: "H:|-10-[titleLabel]-10-|")
            .activate()
        
        layout.with(format: "H:|-10-[descriptionLabel]-10-|")
            .activate()
        
        layout.with(format: "H:|-0-[imageView(200)]-0-|")
            .activate()
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
