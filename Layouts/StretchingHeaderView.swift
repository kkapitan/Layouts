//
//  StretchingHeaderView.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 23.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class StretchingHeaderView: UICollectionReusableView {
    
    let frontImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate var frontImageHeightConstraint: NSLayoutConstraint!
    fileprivate var backImageHeightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        let views: [IdentifiableView] = [
            ("backImageView", backImageView),
            ("frontImageView", frontImageView),
        ]
        
        addSubview(containerView)
        
        let layout = LayoutBuilder(views: views)
        views.map { $0.1 }.forEach(containerView.addSubview)
        
        layout.pin(containerView, to: self)
        
        frontImageHeightConstraint = frontImageView.heightAnchor.constraint(equalToConstant: frontImageHeight)
        backImageHeightConstraint = backImageView.heightAnchor.constraint(equalToConstant: backImageHeight)
        
        [frontImageHeightConstraint, backImageHeightConstraint].activate()
        
        layout.center(frontImageView, in: containerView)
        layout.center(backImageView, in: containerView)
        
        layout.keepRatio(1.0, of: frontImageView)
        layout.keepRatio(1.0, of: backImageView)
        
        frontImageView.layer.masksToBounds = true
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var frontImageHeight: CGFloat = 100.0
    fileprivate var backImageHeight: CGFloat = 600.0

    fileprivate var previousDelta: CGFloat = 0.0
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let attributes = layoutAttributes as? StretchingHeaderLayoutAttributes else { return }
        
        guard let delta = attributes.delta, previousDelta != delta else { return }
        
        frontImageHeightConstraint.constant = frontImageHeight + delta
        backImageHeightConstraint.constant = backImageHeight - delta
        
        frontImageView.layer.cornerRadius = (frontImageHeight + delta) / 2.0
        
        previousDelta = delta
    }
}
