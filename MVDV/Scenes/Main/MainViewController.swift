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

class MainViewController: UIViewController {
    private(set) var db = DisposeBag()
    
    var vm: MainViewModel!
    
    private(set) lazy var mainTabBarController = MainTabViewController()
    
    private var indicator: UIActivityIndicatorView!
    
    override var childForStatusBarStyle: UIViewController? {
        mainTabBarController.childForStatusBarStyle
    }
    
    override var tabBarController: UITabBarController? {
        mainTabBarController
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        UINavigationBar.appearance().tintColor = R.color.tmdbColorTertiaryLightGreen()
        
        addTabBarController()

        createIndicator()
        bindViewModel()
        
        vm.send(action: .ready)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addTabBarController() {
        view.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        view.addSubview(mainTabBarController.view)
        
        addChild(mainTabBarController)
        mainTabBarController.didMove(toParent: self)
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
    
    func processEvent(_ event: MainEvent) {
        switch event {
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
