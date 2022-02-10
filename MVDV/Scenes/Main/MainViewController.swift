//
//  MainViewController.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/20.
//

import UIKit


extension UIViewController {
    var navigationRooted: UINavigationController { CustomNavigationController(rootViewController: self) }
}

class CustomNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        topViewController
    }
}

class MainViewController: UITabBarController {
    override var childForStatusBarStyle: UIViewController? {
        selectedViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = R.color.tmdbColorSecondaryLightBlue()
        tabBar.barTintColor = R.color.tmdbColorPrimaryDarkBlue()
        
        UINavigationBar.appearance().tintColor = R.color.tmdbColorTertiaryLightGreen()
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().isTranslucent = true
        
        viewControllers = [ HomeViewController(),
                            UpcomingViewController(),
                            SearchViewController(),
                            ProfileViewController() ].map { $0.navigationRooted }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
