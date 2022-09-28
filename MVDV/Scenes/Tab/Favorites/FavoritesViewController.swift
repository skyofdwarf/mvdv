//
//  FavoritesViewController.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/21.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxRelay
import Accelerate
import Kingfisher
import AuthenticationServices

class FavoritesViewController: UIViewController {
    
    private var indicator: UIActivityIndicatorView!
    private(set) var db = DisposeBag()
    let vm: FavoritesViewModel
    
    var button: UIButton!
    
    init(vm: FavoritesViewModel) {
        self.vm = vm
        
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: Strings.Common.Favorites.title,
                                       image: UIImage(systemName: "star"),
                                       tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        button = UIButton(type: .custom).then {
            $0.setTitle("Authenticate", for: .normal)
            
            view.addSubview($0)
            
            $0.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        
        createIndicator()
        
        bindViewModel()
    }
    
    func showEvent(_ event: FavoritesEvent) {
        switch event {
        case .alert(let msg):
            alert(message: msg)
        }
    }
}

// MARK: ViewModel

private extension FavoritesViewController {
    func bindViewModel() {
        // inputs
        button.rx.tap
            .map { [weak self] in FavoritesAction.authenticate(self) }
            .bind(to: vm.action)
            .disposed(by: db)
        
        // outputs
        vm.state.$fetching
            .drive(indicator.rx.isAnimating)
            .disposed(by: db)
        
//        vm.state.$sections
//            .drive(rx.dataSource)
//            .disposed(by: db)
        
        vm.event
            .emit(to: rx.event)
            .disposed(by: db)
    }
}


// MARK: UI

private extension FavoritesViewController {
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
}

extension FavoritesViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        view.window ?? UIWindow()
    }
}
    
extension Reactive where Base: FavoritesViewController {
//    var dataSource: Binder<FavoritesState.Sections> {
//        Binder(base) {
//            $0.applyDataSource(sections: $1)
//        }
//    }
    
    var event: Binder<FavoritesEvent> {
        Binder(base) {
            $0.showEvent($1)
        }
    }
}

