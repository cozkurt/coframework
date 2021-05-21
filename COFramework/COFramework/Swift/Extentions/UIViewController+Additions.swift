//
//  UIViewController+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 11/9/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}
