//
//  UpcomingCoordinator.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/10/18.
//

import UIKit

final class UpcomingCoordinator {
    unowned let tabBarController: UITabBarController
    let vc: UpcomingViewController
    
    init(tabBarController: UITabBarController, imageConfiguration: ImageConfiguration) {
        self.tabBarController = tabBarController
        
        self.vc = UpcomingViewController()
        self.vc.vm = UpcomingViewModel(imageConfiguration: imageConfiguration, coordinator: self)
    }
    
    func start() {
    }
    
    func showDetail(movie: Movie, imageConfiguration: ImageConfiguration) {
        MovieDetailCoordinator(navigationController: vc.navigationController)
            .start(movie: movie, imageConfiguration: imageConfiguration)
    }
}
