//
//  MainViewController.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/01/20.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = R.color.tmdbColorSecondaryLightBlue()
        tabBar.barTintColor = R.color.tmdbColorPrimaryDarkBlue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigation = {
            UINavigationController(rootViewController: $0)
                .then {
                    $0.navigationBar.barStyle = .black
                    $0.navigationBar.isTranslucent = true
                    $0.navigationBar.barTintColor = R.color.tmdbColorPrimaryDarkBlue()
                    $0.navigationBar.tintColor = R.color.tmdbColorTertiaryLightGreen()
                    $0.navigationBar.titleTextAttributes = [
                        .foregroundColor: R.color.tmdbColorTertiaryLightGreen()!,
                        .font: UIFont.boldSystemFont(ofSize: 24),
                    ]
                }
        }
        
        viewControllers = [ navigation(HomeViewController()),
                            navigation(UpcomingViewController()),
                            navigation(SearchViewController()),
                            navigation(ProfileViewController()) ]
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
