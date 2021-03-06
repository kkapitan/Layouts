//
//  ExpandingItem.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 23.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import Foundation

struct ExpandingItem {
    let title: String
    let imageURL: URL
    
    init(title: String) {
        self.title = title
        self.imageURL = URL(string: "https://unsplash.it/200/200/?random")!
    }
}
