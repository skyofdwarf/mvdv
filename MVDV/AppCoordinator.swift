//
//  AppCoordinator.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/10/17.
//

import UIKit

final class AppCoordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.makeKeyAndVisible()
        
        MainCoordinator(window: window).start()
    }
}
