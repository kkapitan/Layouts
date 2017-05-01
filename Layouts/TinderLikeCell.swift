//
//  TinderLikeCell.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 01.05.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class TinderCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.font = UIFont(name: "American Typewriter", size: 18.0)
        
        label.allowsDefaultTighteningForTruncation = true
        label.adjustsFontSizeToFitWidth = true
        
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont(name: "American Typewriter", size: 14.0)
        return label
    }()
    
    let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        let views: [IdentifiableView] = [
            ("nameLabel", nameLabel),
            ("descriptionLabel", descriptionLabel),
            ("imageView", pictureImageView),
        ]
        
        addSubview(containerView)
        
        let layout = LayoutBuilder(views: views)
        views.map { $0.1 }.forEach(containerView.addSubview)
        
        layout.pin(containerView, to: self)
        
        layout.with(format: "V:|-10-[imageView]-10-[nameLabel]-10-[descriptionLabel]-10-|",
                    options: [.alignAllLeading, .alignAllTrailing])
            .activate()
        
        layout.with(format: "H:|-10-[imageView]-10-|")
            .activate()
        
        backgroundColor = .white
    }
    
    override func draw(_ rect: CGRect) {
        let borderWidth: CGFloat = 4.0
        let borderColor: UIColor = .black
        
        let borderRet = rect.insetBy(dx: borderWidth / 2.0, dy: borderWidth / 2.0)
        let borderPath = UIBezierPath(rect: borderRet)
        
        borderPath.lineWidth = borderWidth
        
        borderColor.setStroke()
        borderPath.stroke()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
