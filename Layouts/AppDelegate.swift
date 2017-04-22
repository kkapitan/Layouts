//
//  AppDelegate.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 22.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let menuViewController = MenuViewController(style: .grouped)
        let navigationController = UINavigationController(rootViewController: menuViewController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

