//
//  TinderLikeImages.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 02.05.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

extension UIImage {
    static func heart(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let initial = CGRect(origin: .zero, size: size)
        
        let lineWidth = CGFloat(2.0)
        UIColor.green.setStroke()
        
        let frame = initial.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
        
        let path = UIBezierPath.heartIn(frame)
        path.lineWidth = lineWidth
        path.stroke()
        
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height))
        
        ovalPath.lineWidth = lineWidth
        ovalPath.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image
    }
    
    static func cross(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let initial = CGRect(origin: .zero, size: size)
        
        
        let lineWidth = CGFloat(2.0)
        UIColor.red.setStroke()
        
        let rect = initial.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
        
        let border = UIBezierPath(ovalIn: rect)
        border.lineWidth = lineWidth
        border.stroke()
        
        let path = UIBezierPath.crossIn(rect)
        path.lineWidth = 2*lineWidth
        path.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image
    }
}
