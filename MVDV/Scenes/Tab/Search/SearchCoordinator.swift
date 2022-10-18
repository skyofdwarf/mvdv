//
//  SearchCoordinator.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/10/18.
//

import UIKit

final class SearchCoordinator {
    unowned let tabBarController: UITabBarController
    let vc: SearchViewController
    
    init(tabBarController: UITabBarController, imageConfiguration: ImageConfiguration) {
        self.tabBarController = tabBarController
        
        self.vc = SearchViewController()
        self.vc.vm = SearchViewModel(imageConfiguration: imageConfiguration, coordinator: self)
    }
    
    func start() {
    }
    
    func showDetail(movie: Movie, imageConfiguration: ImageConfiguration) {
        MovieDetailCoordinator(navigationController: vc.navigationController)
            .start(movie: movie, imageConfiguration: imageConfiguration)
    }
}
