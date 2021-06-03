//
//  AppearanceTextView.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit

public class AppearanceTextView: UITextView {
    
    @IBInspectable public var appearanceId: String? {
        didSet {
            if self.appearanceId != "" {
                AppearanceController.sharedInstance.customizeTextView(self)
            }
        }
    }
    
    @IBInspectable public var useDefaultFont: Bool = false

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setDefaults()
    }
    
    public func setDefaults() {
        if useDefaultFont {
            if let font = self.font {
                self.font = font.appearanceFont(fontDefault: defaultFontName, size: font.pointSize)
            }
            self.textColor = AppearanceController.sharedInstance.color("default.text")
        }
    }
}
