//
//  CarouselCollectionView.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 22.04.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit
import Kingfisher

final class CarouselCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    fileprivate static let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.estimatedItemSize = CGSize(width: 350.0, height: 300.0)
        layout.minimumLineSpacing = 30.0
        layout.minimumInteritemSpacing = 30.0
        
        return layout
    }()
    
    
    fileprivate let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    fileprivate let items: [CarouselItem] = {
       return [
        CarouselItem(title: "Title 1", description: "Some very useful description"),
        CarouselItem(title: "Title 2", description: "Some very useful description"),
        CarouselItem(title: "Title 3", description: "Some very useful description"),
        CarouselItem(title: "Title 4", description: "Some very useful description"),
        CarouselItem(title: "Title 5", description: "Some very useful description"),
        CarouselItem(title: "Title 6", description: "Some very useful description. Very very useful. adas kaposdk poasd adkp oaskd pasd askdpoas kpdkas dsad kpasd apsdk apodkpa dk aspdk pasdoa spdk padkpak")
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        LayoutBuilder().pin(collectionView, to: view)
        
        collectionView.registerClass(CarouselCell.self)
        collectionView.backgroundColor = .red
        
        collectionView.dataSource = self
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let item = items[indexPath.row]
        let cell: CarouselCell = collectionView.dequeue(for: indexPath)
        
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.description
        cell.imageView.kf.setImage(with: item.imageURL)
        
        return cell
    }
}

final class CarouselFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        print("Hey")
        return true
    }
}

final class CarouselCell: UICollectionViewCell {
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        let views: [IdentifiableView] = [
            ("imageView", imageView),
            ("titleLabel", titleLabel),
            ("descriptionLabel", descriptionLabel)
        ]
        
        let layout = LayoutBuilder(views: views)
        views.map { $0.1 }.forEach(contentView.addSubview)
        
        layout.with(format: "V:|-0-[imageView(200)]-10-[titleLabel]-10-[descriptionLabel]-10-|",
            options: [.alignAllLeading, .alignAllTrailing])
            .activate()
        
        layout.with(format: "H:|-0-[imageView(200)]-0-|")
            .activate()
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct CarouselItem {
    let title: String
    let description: String
    
    let imageURL: URL
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
        self.imageURL = URL(string: "https://unsplash.it/200/200/?random")!
    }
}

