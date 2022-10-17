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
    let vm: MainViewModel
    
    private var indicator: UIActivityIndicatorView!
    
    override var childForStatusBarStyle: UIViewController? {
        selectedViewController
    }
    
    init(vm: MainViewModel) {
        self.vm = vm
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        vm.send(action: .ready)
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
    
    func processEvent(_ event: MainEvent) {
        switch event {
        case .ready(let imageConfiguration):
            showTabs(imageConfiguration: imageConfiguration)
        case .alert(let msg):
            alert(message: msg)
        }
    }
}

extension Reactive where Base: MainViewController {
    var event: Binder<MainEvent> {
        Binder(base) {
            $0.processEvent($1)
        }
    }
}
