//
//  TinderLikeItem.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 01.05.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import Foundation

struct TinderItem {
    
    let title: String
    let description: String
    let imageURL: URL
    
    init(title: String, description: String, imageURL: URL) {
        self.title = title
        self.description = description
        
        self.imageURL = URL(string: "https://unsplash.it/200/200/?random")!
    }
}

extension TinderItem {
    static func random() -> TinderItem {
        
        let random = 1 + Int(arc4random()) % 100
        let url = URL(string: "https://randomuser.me/api/portraits/women/\(random).jpg")!
        
        return TinderItem(title: "Jane Doe",
                          description: LoremIpsum.random(),
                          imageURL: url)
    }
}
