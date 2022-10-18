//
//  ProfileCoordinator.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/10/18.
//

import UIKit

final class ProfileCoordinator {
    unowned let tabBarController: UITabBarController
    let vc: ProfileViewController
    
    init(tabBarController: UITabBarController, imageConfiguration: ImageConfiguration) {
        self.tabBarController = tabBarController
        
        self.vc = ProfileViewController()
        self.vc.vm = ProfileViewModel(imageConfiguration: imageConfiguration, coordinator: self)
    }
    
    func start() {
    }
    
    func showFavorites(imageConfiguration: ImageConfiguration) {
        FavoritesCoordinator(navigationController: vc.navigationController)
            .start(imageConfiguration: imageConfiguration)
    }
}
