//
//  MainViewController.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

extension UIViewController {
    var navigationRooted: UINavigationController { CustomNavigationController(rootViewController: self) }
}

class CustomNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        topViewController
    }
}

class MainViewController: UITabBarController {
    private(set) var db = DisposeBag()
    let vm = MainViewModel()
    
    private var indicator: UIActivityIndicatorView!
    
    override var childForStatusBarStyle: UIViewController? {
        selectedViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        tabBar.tintColor = R.color.tmdbColorSecondaryLightBlue()
        tabBar.barTintColor = R.color.tmdbColorPrimaryDarkBlue()
        
        UINavigationBar.appearance().tintColor = R.color.tmdbColorTertiaryLightGreen()

        viewControllers = []
        
        createIndicator()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: ViewModel

private extension MainViewController {
    func bindViewModel() {
        vm.state.$fetching
            .drive(indicator.rx.isAnimating)
            .disposed(by: db)
        
        vm.state.$imageConfiguration
            .compactMap { $0 }
            .drive(rx.imageConfiguration)
            .disposed(by: db)
        
        vm.event
            .emit(to: rx.event)
            .disposed(by: db)
    }
    
    func createIndicator() {
        indicator = UIActivityIndicatorView(style: .large).then {
            view.addSubview($0)
            
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            $0.color = R.color.tmdbColorTertiaryLightGreen()
            $0.hidesWhenStopped = true
        }
    }
    
    func showTabs(imageConfiguration: ImageConfiguration) {
        viewControllers = [
            HomeViewController(vm: HomeViewModel(imageConfiguration: imageConfiguration)),
            UpcomingViewController(vm: UpcomingViewModel(imageConfiguration: imageConfiguration)),
            SearchViewController(vm: SearchViewModel(imageConfiguration: imageConfiguration)),
            ProfileViewController(vm: ProfileViewModel(imageConfiguration: imageConfiguration))
        ].map { $0.navigationRooted }
    }
    
    func showEvent(_ event: MainEvent) {
        switch event {
        case .alert(let msg):
            alert(message: msg)
        }
    }
}

extension Reactive where Base: MainViewController {
    var imageConfiguration: Binder<ImageConfiguration> {
        Binder(base) {
            $0.showTabs(imageConfiguration: $1)
        }
    }
    
    var event: Binder<MainEvent> {
        Binder(base) {
            $0.showEvent($1)
        }
    }
}
