//
//  MainTabViewController.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/10/18.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

class MainTabViewController: UITabBarController {
    private(set) var db = DisposeBag()
    
    private var indicator: UIActivityIndicatorView!
    
    override var childForStatusBarStyle: UIViewController? {
        selectedViewController
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = R.color.tmdbColorSecondaryLightBlue()
        tabBar.barTintColor = R.color.tmdbColorPrimaryDarkBlue()
        
        viewControllers = []
    }
}
