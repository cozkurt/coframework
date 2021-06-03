//
//  AppearanceModel.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 03/17/17.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit

public class AppearanceView: UIView {
    
    @IBInspectable public var appearanceId: String? {
        didSet {
            if self.appearanceId != "" {
                AppearanceController.sharedInstance.customizeView(self)
            }
        }
    }
}
