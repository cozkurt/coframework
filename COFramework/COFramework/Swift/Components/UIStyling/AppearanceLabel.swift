//
//  AppearanceLabel.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit

public class AppearanceLabel: UILabel {
    
    @IBInspectable public var appearanceId: String? {
        didSet {
            if self.appearanceId != "" {
                AppearanceController.sharedInstance.customizeLabel(self)
            }
        }
    }
	
    @IBInspectable public var useDefaultFont: Bool = false

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setDefaults()
    }
	
    public func setDefaults() {
		if useDefaultFont {
            self.font = self.font.appearanceFont(fontDefault: defaultFontName, size: self.font.pointSize)
			self.textColor = AppearanceController.sharedInstance.color("default.text")
		}
	}
}
