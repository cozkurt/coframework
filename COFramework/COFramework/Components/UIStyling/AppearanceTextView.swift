//
//  AppearanceTextView.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit

open class AppearanceTextView: UITextView {
    
    @IBInspectable open var appearanceId: String? {
        didSet {
            if self.appearanceId != "" {
                AppearanceController.sharedInstance.customizeTextView(self)
            }
        }
    }
    
    @IBInspectable open var useDefaultFont: Bool = false

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
    }
}
