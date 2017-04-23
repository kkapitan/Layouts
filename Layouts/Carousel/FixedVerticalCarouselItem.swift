//
//  FixedVerticalCarouselItem.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 22.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import Foundation

struct FixedVerticalCarouselItem {
    let title: String
    let description: String
    
    let imageURL: URL
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
        self.imageURL = URL(string: "https://unsplash.it/200/200/?random")!
    }
}
