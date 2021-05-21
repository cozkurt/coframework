//
//  UIFont+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

extension UIFont {
    
	@objc func mediumWeight() -> UIFont? {
		if let fontName = self.fontName.split(separator: "-").first {
			return UIFont(name: "\(fontName)-Medium", size: self.pointSize)
		}
		return nil
	}
	
	@objc func regularWeight() -> UIFont? {
		if let fontName = self.fontName.split(separator: "-").first {
			return UIFont(name: "\(fontName)", size: self.pointSize)
		}
		return nil
	}
	
	// For Theme use
    class func defaultFontWithSize(fontDefault: String, ofSize fontSize: CGFloat, andWeight weight: UIFont.Weight) -> UIFont? {
        
		if fontDefault.lowercased() == "system" {
			return UIFont.systemFont(ofSize: fontSize, weight: weight)
		}
		
		var fontWeight = "Regular"
		
		switch weight {
		case UIFont.Weight.light:
			fontWeight = "Light"
		case UIFont.Weight.regular:
			fontWeight = "Regular"
		case UIFont.Weight.medium:
			fontWeight = "Medium"
		case UIFont.Weight.bold:
			fontWeight = "Bold"
		default:
			break
		}
        
        // This is custom font mapping if
        // font family is not the same
        
        return UIFont(name: "\(fontDefault)-\(fontWeight)", size: fontSize)	}
    
    func appearanceFont(fontDefault: String, size: CGFloat) -> UIFont? {
        return UIFont.defaultFontWithSize(fontDefault: fontDefault, ofSize: size, andWeight: self.weight())
    }
	
	func weight() -> UIFont.Weight {
		
		if let fontWeight = self.fontDescriptor.object(forKey: UIFontDescriptor.AttributeName.face) as? String {
            
			switch fontWeight {
                
			case "Bold":
				return UIFont.Weight.bold
				
			case "Light":
				return UIFont.Weight.light
				
			case "Medium":
				return UIFont.Weight.medium

			case "Regular":
				return UIFont.Weight.regular
				
			default:
				return UIFont.Weight.regular
			}
		}
		
		return UIFont.Weight.regular
	}
}
