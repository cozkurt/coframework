//
//  AppearanceTextField.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit

open class AppearanceTextField: UITextField {
    
    @IBInspectable open var appearanceId: String? {
        didSet {
            if self.appearanceId != "" {
                AppearanceController.sharedInstance.customizeTextField(self)
            }
        }
    }
    
    @IBInspectable open var useDefaultFont: Bool = false
    @IBInspectable open var useDefaultCursorColor: Bool = true

    open override func awakeFromNib() {
        super.awakeFromNib()
        
        setDefaults()
    }
    
    open func setDefaults() {
        if useDefaultFont {
            if let font = self.font {
                self.font = font.appearanceFont(fontDefault: defaultFontName, size: font.pointSize)
            }
            self.textColor = AppearanceController.sharedInstance.color("default.text")
        }
        
        if useDefaultCursorColor {
            self.tintColor = AppearanceController.sharedInstance.color("default.text.cursor")
        }
    }
}
