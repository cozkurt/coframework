//
//  AppearanceTextField.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit

public class AppearanceTextField: UITextField {
    
    @IBInspectable public var appearanceId: String? {
        didSet {
            if self.appearanceId != "" {
                AppearanceController.sharedInstance.customizeTextField(self)
            }
        }
    }
    
    @IBInspectable public var useDefaultFont: Bool = false
    @IBInspectable public var useDefaultCursorColor: Bool = true

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setDefaults()
    }
    
    public func setDefaults() {
        if useDefaultFont {
            if let font = self.font {
                self.font = font.appearanceFont(fontDefault: AppearanceController.sharedInstance.defaultFontName, size: font.pointSize)
            }
            self.textColor = AppearanceController.sharedInstance.color("default.text")
        }
        
        if useDefaultCursorColor {
            self.tintColor = AppearanceController.sharedInstance.color("default.text.cursor")
        }
    }
}
