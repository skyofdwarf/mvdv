//
//  MainCoordinator.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/10/18.
//

import UIKit

final class MainCoordinator {
    let window: UIWindow
    var vc: MainViewController!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        vc = MainViewController()
        vc.vm = MainViewModel(dataStorage: DataStorage.shared, coordinator: self)
        
        vc.mainTabBarController.viewControllers = []
        
        window.rootViewController = vc
    }
    
    func showTabs(imageConfiguration: ImageConfiguration) {
        vc.mainTabBarController.viewControllers = [
            HomeCoordinator(tabBarController: vc.mainTabBarController, imageConfiguration: imageConfiguration).vc,
            UpcomingCoordinator(tabBarController: vc.mainTabBarController, imageConfiguration: imageConfiguration).vc,
            SearchCoordinator(tabBarController: vc.mainTabBarController, imageConfiguration: imageConfiguration).vc,
            ProfileCoordinator(tabBarController: vc.mainTabBarController, imageConfiguration: imageConfiguration).vc,
        ].map { $0.navigationRooted }
    }
}
