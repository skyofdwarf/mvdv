//
//  UIViewController+Extension.swift
//  MVDV
//
//  Created by YEONGJUNG KIM on 2022/02/15.
//

import UIKit

extension UIViewController {
    func alert(message: String,
               title: String? = Strings.Common.Alert.title,               
               confirmTitle: String = Strings.Common.Alert.ok) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default))
        present(alert, animated: true, completion: nil)
    }
}
