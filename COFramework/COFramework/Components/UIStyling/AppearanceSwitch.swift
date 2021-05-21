//
//  AppearanceSwitch.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/9/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit

open class AppearanceSwitch: UISwitch {
    
    @IBInspectable open var appearanceId: String? {
        didSet {
            if self.appearanceId != "" {
                AppearanceController.sharedInstance.customizeSwitch(self)
            }
        }
    }
}
