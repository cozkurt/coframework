//
//  UIPageViewController+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 12/3/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit

extension UIPageViewController {
    public var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}
