//
//  LoremIpsum.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 22.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import Foundation

struct LoremIpsum {
    
    fileprivate static let container: [String] = {
        return "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire".components(separatedBy: " ")
    }()
    
    fileprivate static var maxLength: Int {
        return container.count
    }
    
    static func generate(length: Int) -> String {
        let actualLength = min(max(1, length), maxLength)
        
        return container.dropLast(maxLength - actualLength).joined(separator: " ")
    }
    
    static func random() -> String {
        let random = 1 + Int(arc4random()) % maxLength
        return generate(length: random)
    }
}
