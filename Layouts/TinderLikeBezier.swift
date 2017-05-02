//
//  TinderLikeBezier.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 02.05.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    static func crossIn(_ rect: CGRect) -> UIBezierPath {
        
        let radius = rect.width / 2.0
        let path = UIBezierPath()
        
        for i in [1,3,5,7] {
            
            let x = radius * cos(CGFloat(i) * CGFloat.pi/4.0) + rect.midX
            let y = radius * sin(CGFloat(i) * CGFloat.pi/4.0) + rect.midY
            
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
    
    static func heartIn(_ rect: CGRect) -> UIBezierPath {
        
        let frame = rect
        
        let heartPath = UIBezierPath()
        heartPath.move(to: CGPoint(x: frame.minX + 0.46677 * frame.width, y: frame.minY + 0.91183 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.36700 * frame.width, y: frame.minY + 0.81724 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.44879 * frame.width, y: frame.minY + 0.88999 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.40389 * frame.width, y: frame.minY + 0.84743 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.19842 * frame.width, y: frame.minY + 0.67055 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.25768 * frame.width, y: frame.minY + 0.72778 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.24280 * frame.width, y: frame.minY + 0.71484 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.08261 * frame.width, y: frame.minY + 0.39427 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.11659 * frame.width, y: frame.minY + 0.58891 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.08249 * frame.width, y: frame.minY + 0.50491 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.09947 * frame.width, y: frame.minY + 0.28846 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.08267 * frame.width, y: frame.minY + 0.34026 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.08544 * frame.width, y: frame.minY + 0.32046 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.20317 * frame.width, y: frame.minY + 0.16914 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.12327 * frame.width, y: frame.minY + 0.23416 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.15834 * frame.width, y: frame.minY + 0.19382 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.30426 * frame.width, y: frame.minY + 0.14766 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.23493 * frame.width, y: frame.minY + 0.15167 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.25123 * frame.width, y: frame.minY + 0.14798 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.40339 * frame.width, y: frame.minY + 0.16968 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.35973 * frame.width, y: frame.minY + 0.14733 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.37076 * frame.width, y: frame.minY + 0.15026 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.49243 * frame.width, y: frame.minY + 0.27974 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.44310 * frame.width, y: frame.minY + 0.19333 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.48398 * frame.width, y: frame.minY + 0.24385 * frame.height))
        heartPath.addLine(to: CGPoint(x: frame.minX + 0.49765 * frame.width, y: frame.minY + 0.30191 * frame.height))
        heartPath.addLine(to: CGPoint(x: frame.minX + 0.51052 * frame.width, y: frame.minY + 0.27138 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.65796 * frame.width, y: frame.minY + 0.14744 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.54018 * frame.width, y: frame.minY + 0.20103 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.59635 * frame.width, y: frame.minY + 0.15979 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.89625 * frame.width, y: frame.minY + 0.27567 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.74745 * frame.width, y: frame.minY + 0.12950 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.84840 * frame.width, y: frame.minY + 0.17248 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.90197 * frame.width, y: frame.minY + 0.51544 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.92189 * frame.width, y: frame.minY + 0.33094 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.92470 * frame.width, y: frame.minY + 0.44896 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.68789 * frame.width, y: frame.minY + 0.76958 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.87232 * frame.width, y: frame.minY + 0.60216 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.81663 * frame.width, y: frame.minY + 0.66827 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.50124 * frame.width, y: frame.minY + 0.95067 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.60345 * frame.width, y: frame.minY + 0.83602 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.50790 * frame.width, y: frame.minY + 0.93655 * frame.height))
        heartPath.addCurve(to: CGPoint(x: frame.minX + 0.46677 * frame.width, y: frame.minY + 0.91183 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.49352 * frame.width, y: frame.minY + 0.96706 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.50088 * frame.width, y: frame.minY + 0.95324 * frame.height))
        heartPath.close()
        
        
        heartPath.miterLimit = 4
        
        return heartPath
    }
}
