//
//  AppearanceImageView.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit

@IBDesignable
public class AppearanceImageView: UIImageView {
    
    @IBInspectable public var appearanceId: String? {
        didSet {
            if self.appearanceId != "" {
                AppearanceController.sharedInstance.customizeImageView(self)
            }
        }
    }
    
    @IBInspectable public var useDefaultTint: Bool = false {
        didSet {
            self.tintColor = AppearanceController.sharedInstance.color("default.image.tint")
			self.setImageWithAlwaysTemplate()
        }
    }
    
    @IBInspectable public var imageName: String? {
        didSet {
            self.image = self.localizedImage(imageName ?? "")
        }
    }
    
    override public func prepareForInterfaceBuilder() {
        let bundle = Bundle(for: type(of: self))
        
        self.image = self.localizedImage(imageName ?? "", bundle: bundle)
    }
    
    public func localizedImage(_ imageName: String, bundle: Bundle? = nil) -> UIImage? {
        let id = Locale.current.identifier
        
        let localizedName = id == "en" ? imageName : "\(imageName)_\(id)"
        
        if let bundle = bundle {
            if let image = UIImage(named: localizedName, in: bundle, compatibleWith: self.traitCollection) {
                return image
            }
        } else {
            if let image = UIImage(systemName: localizedName) {
                return image
            }
            
            if let image = UIImage(named: localizedName) {
                return image
            }
        }
        
        return UIImage(systemName: imageName) ?? UIImage(named: imageName)
    }
    
    public func setImageWithAlwaysTemplate(name: String) {
        self.image = self.localizedImage(name)?.withRenderingMode(.alwaysTemplate)
    }
 
    public func setImageWithAlwaysTemplate() {
		if useDefaultTint {
			self.image = self.image?.withRenderingMode(.alwaysTemplate)
		}
	}
}
