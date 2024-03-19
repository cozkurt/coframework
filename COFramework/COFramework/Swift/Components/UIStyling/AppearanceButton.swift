//
//  AppearanceButton.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit

@IBDesignable
public class AppearanceButton: UIButton {
    
    @IBInspectable public var appearanceId: String? {
        didSet {
            if self.appearanceId != "" {
                AppearanceController.sharedInstance.customizeButton(self)
            }
        }
    }
	
	@IBInspectable public var useDefaultFont: Bool = false
	@IBInspectable public var useDefaultTint: Bool = false
    
    @IBInspectable public var borderColor: UIColor? {
        didSet {
            if let bColor = borderColor {
                self.layer.borderColor = bColor.cgColor
            }
        }
    }

    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setDefaults()
        self.setForLocalization()
    }
	
	public func setDefaults() {
		if useDefaultFont {
            if let size = self.titleLabel?.font.pointSize {
                self.titleLabel?.font = self.titleLabel?.font.appearanceFont(fontDefault: AppearanceController.sharedInstance.defaultFontName, size: size)
            }
			self.setTitleColor(AppearanceController.sharedInstance.color("default.color"), for: .normal)
		}
        
        if useDefaultTint {
            self.tintColor = AppearanceController.sharedInstance.color("default.image.tint")
            
            let image = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
            self.setImage(image, for: .normal)
        }
	}
    
    public func setForLocalization() {
        // Adjust font for localization
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.minimumScaleFactor = 0.8
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = .byClipping
        self.titleLabel?.textAlignment = .center
    }
    
    override public var isHighlighted: Bool {
        didSet {
            guard let currentBorderColor = borderColor else {
                return
            }

            let fadedColor = currentBorderColor.withAlphaComponent(0.2).cgColor

            if isHighlighted {
                layer.borderColor = fadedColor
            } else {

                self.layer.borderColor = currentBorderColor.cgColor

                let animation = CABasicAnimation(keyPath: "borderColor")
                animation.fromValue = fadedColor
                animation.toValue = currentBorderColor.cgColor
                animation.duration = 0.4
                self.layer.add(animation, forKey: "")
            }
        }
    }
}
