//
//  MovieDetailCoordinator.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/10/18.
//

import UIKit

final class MovieDetailCoordinator {
    private(set) weak var navigationController: UINavigationController?
    
    private(set) var vc: MovieDetailViewController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start(movie: Movie, imageConfiguration: ImageConfiguration) {
        let vc = MovieDetailViewController()
        vc.vm = MovieDetailViewModel(movie: movie, imageConfiguration: imageConfiguration, coordinator: self)
        
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
