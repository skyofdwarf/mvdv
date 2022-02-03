//
//  ProfileViewController.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/21.
//

import UIKit

class ProfileViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: Strings.Common.Title.profile,
                                       image: UIImage(systemName: "person"),
                                       tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
