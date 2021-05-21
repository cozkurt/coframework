//
//  UIViewController+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 11/9/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit

extension UIViewController {

    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.closeKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    func registerForKeyboardWillShowNotification(_ scrollView: UIScrollView) {
        NotificationsCenterManager.sharedInstance.addObserver(self, forName: UIResponder.keyboardWillShowNotification.rawValue) { (notification) in
            let userInfo = notification.userInfo!
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: keyboardSize.height, right: scrollView.contentInset.right)

            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }

    func registerForKeyboardWillHideNotification(_ scrollView: UIScrollView) {
        NotificationsCenterManager.sharedInstance.addObserver(self, forName: UIResponder.keyboardWillHideNotification.rawValue) { (notification) in

            scrollView.contentInset = UIEdgeInsets.zero
            scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
    }
    
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
