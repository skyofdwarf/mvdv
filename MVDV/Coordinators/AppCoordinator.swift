//
//  AppCoordinator.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/10/17.
//

import UIKit

final class AppCoordinator {
    let window: UIWindow
    let tabBarController: MainViewController
    
    init(window: UIWindow) {
        self.window = window
        
        let vm = MainViewModel(dataStorage: DataStorage.shared)
        let vc = MainViewController(vm: vm)
        
        self.tabBarController = vc
    }
    
    func start() {
        window.rootViewController = self.tabBarController
        window.makeKeyAndVisible()
    }
}
