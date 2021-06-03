//
//  UIColor+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

extension UIColor {

    /**
     The six-digit hexadecimal representation of color of the form #RRGGBB.
     
     - parameter hex: Six-digit hexadecimal value.
     */
    public convenience init(hex: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat(hex & 0x0000FF) / divisor
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
	
	/**
	Convenience method to construct a UIColor using simple RGB value
	
	- parameter rgb: RGB tuple
	-returns: an UIColor instance that represent the required color
	*/
    public convenience init(_ rgb: (Int, Int, Int)) {
		self.init(
			red: CGFloat(rgb.0) / 255.0,
			green: CGFloat(rgb.1) / 255.0,
			blue: CGFloat(rgb.2) / 255.0,
			alpha: 1.0
		)
	}
    	
	/**
	Returns a lighter color by the provided percentage
	
	- parameter percent: lighting percent percentage
	- returns: lighter UIColor
	*/
    public  func lighterColor(_ percent : Double) -> UIColor {
		return colorWithBrightnessFactor(CGFloat(1 + percent));
	}
	
	/**
	Returns a darker color by the provided percentage
	
	- parameter percent: darking percent percentage
	- returns: darker UIColor
	*/
    public  func darkerColor(_ percent : Double) -> UIColor {
		return colorWithBrightnessFactor(CGFloat(1 - percent));
	}
	
	/**
	Return a modified color using the brightness factor provided
	
	- parameter factor: brightness factor
	- returns: modified color
	*/
    public  func colorWithBrightnessFactor(_ factor: CGFloat) -> UIColor {
		var hue : CGFloat = 0
		var saturation : CGFloat = 0
		var brightness : CGFloat = 0
		var alpha : CGFloat = 0
		
		if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
			return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
		} else {
			return self;
		}
    }
}
