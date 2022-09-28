//
//  FavoritesViewController.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/21.
//

import UIKit

class FavoritesViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: Strings.Common.Favorites.title,
                                       image: UIImage(systemName: "star"),
                                       tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
}
