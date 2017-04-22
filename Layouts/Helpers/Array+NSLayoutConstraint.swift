//
//  Array+NSLayoutConstraint.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 22.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

public extension Array where Element: NSLayoutConstraint {
    
    private func setActive(_ active: Bool) {
        active ? NSLayoutConstraint.activate(self) : NSLayoutConstraint.deactivate(self)
    }
    
    func activate() {
        setActive(true)
    }
    
    func deactivate() {
        setActive(false)
    }
}
