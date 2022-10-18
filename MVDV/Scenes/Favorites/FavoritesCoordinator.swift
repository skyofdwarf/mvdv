//
//  FavoritesCoordinator.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/10/18.
//

import UIKit

final class FavoritesCoordinator {
    private(set) weak var navigationController: UINavigationController?
    
    private(set) var vc: FavoritesViewController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start(imageConfiguration: ImageConfiguration) {
        let vc = FavoritesViewController()
        vc.vm = FavoritesViewModel(imageConfiguration: imageConfiguration, coordinator: self)
        
        navigationController?.pushViewController(vc, animated: true)
        
        self.vc = vc
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }

    func showDetail(movie: Movie, imageConfiguration: ImageConfiguration) {
        MovieDetailCoordinator(navigationController: vc?.navigationController)
            .start(movie: movie, imageConfiguration: imageConfiguration)
    }
}
