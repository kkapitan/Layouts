//
//  TinderLikeDecorationViews.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 02.05.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit


final class AcceptView: UICollectionReusableView {
    static let kind = "AcceptViewKind"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let lineWidth = CGFloat(5.0)
        UIColor.green.withAlphaComponent(0.8).setStroke()
        
        let frame = rect.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
        
        let path = UIBezierPath.heartIn(frame)
        path.lineWidth = lineWidth
        path.stroke()
        
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height))
        
        ovalPath.lineWidth = lineWidth
        ovalPath.stroke()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class DeclineView: UICollectionReusableView {
    static let kind = "DeclineViewKind"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let lineWidth = CGFloat(5.0)
        UIColor.red.withAlphaComponent(0.8).setStroke()
        
        let rect = rect.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
        
        let border = UIBezierPath(ovalIn: rect)
        border.lineWidth = lineWidth
        border.stroke()
        
        let path = UIBezierPath.crossIn(rect)
        path.lineWidth = 2 * lineWidth
        path.stroke()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
