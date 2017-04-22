//
//  MenuViewController.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 22.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit

final class MenuViewController: UITableViewController {
    
    fileprivate let entries: [MenuEntry] = {
       return [
            MenuEntry(title: "Simple Flow Layout Autoresizing",
                      controllerClass: AutoresizingViewController.self),
            MenuEntry(title: "Carousel + Autoresizing",
                      controllerClass: CarouselViewController.self)
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(MenuViewCell.self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MenuViewCell = tableView.dequeue()
        let entry = menuEntry(at: indexPath)
        
        cell.title = entry.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = menuEntry(at: indexPath)
        let controllerClass = entry.controllerClass
        
        let collectionViewController = controllerClass.init()
        navigationController?.pushViewController(collectionViewController, animated: true)
    }
    
    fileprivate func menuEntry(at indexPath: IndexPath) -> MenuEntry {
        return entries[indexPath.row]
    }
}

final class MenuViewCell: UITableViewCell {
    var title: String? {
        didSet {
            textLabel?.text = title
        }
    }
}

struct MenuEntry {
    let title: String
    let controllerClass: UIViewController.Type
}
