//
//  AppearanceLabel.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit

open class AppearanceLabel: UILabel {
    
    @IBInspectable open var appearanceId: String? {
        didSet {
            if self.appearanceId != "" {
                AppearanceController.sharedInstance.customizeLabel(self)
            }
        }
    }
	
    @IBInspectable open var useDefaultFont: Bool = false

    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setDefaults()
    }
	
	open func setDefaults() {
		if useDefaultFont {
            self.font = self.font.appearanceFont(fontDefault: defaultFontName, size: self.font.pointSize)
			self.textColor = AppearanceController.sharedInstance.color("default.text")
		}
	}
}
