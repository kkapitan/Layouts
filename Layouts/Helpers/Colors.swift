//
//  Colors.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 22.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let alzarin: UIColor = {
        return UIColor(hex: "e74c3c")
    }()
    
    static let asbestos: UIColor = {
        return UIColor(hex: "7f8c8d")
    }()
    
    static let pomegranate: UIColor = {
        return UIColor(hex: "c0392b")
    }()
}

fileprivate extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha
        )
    }
}
