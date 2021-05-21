//
//  AppearanceSegmented.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//


import UIKit

open class AppearanceSegmented: UISegmentedControl {
    
    @IBInspectable open var appearanceId: String? {
        didSet {
            if self.appearanceId != "" {
                AppearanceController.sharedInstance.customizeSegmentedControl(self)
            }
        }
    }
}
