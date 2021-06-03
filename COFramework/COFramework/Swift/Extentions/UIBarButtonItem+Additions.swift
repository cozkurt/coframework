//
//  UIBarButtonItem.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 11/14/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    public var isHidden: Bool {
        get {
            return !isEnabled && tintColor == .clear
        }
        set {
            tintColor = newValue ? .clear : nil
            isEnabled = !newValue
        }
    }
}
