//
//  AppearanceHelpers.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit
import Foundation

open class AppearanceHelpers {
    
    // MARK: - Helper Methods
    
    /**
     convertToUIFont convert font values to UIFont object
     
     - parameters:
     - font: validate "font-name,font-size" format
     
     - returns:    UIFont?
     */
    
    func convertToUIFont(_ font: String) -> UIFont? {
        
        let values: Array = font.components(separatedBy: ",")
        
        if values.count != 2 { return nil }
        
        guard let fontName = values.first, let fontSize = Float(values[1]) else {
            return nil
        }
        
        let fontSplitVals: Array = fontName.components(separatedBy: "-")
        
        if fontSplitVals.count != 2 { return nil }
        
        guard let uiFont = fontSplitVals[0].lowercased() == "system" ? UIFont.systemFont(ofSize: CGFloat(fontSize), weight: fontSplitVals[1].asFontWeight()) : UIFont(name: fontName, size: CGFloat(fontSize)) else {
            return nil
        }
        
        if fontName != "" && fontSize > 0 {
            return uiFont
        } else {
            return nil
        }
    }
    
    /**
     convertToUIColor convert validated r,g,b,a values to
     UIColor Object
     
     - parameters:
     rgbColors: validate "r,g,b,a" format and values are between 0..255 and 0..1 for alpha
     
     - returns:    UIColor
     */
    
    func convertToUIColor(_ rgbColors: String, searchColors: Bool = true) -> UIColor? {
        
        // look for if color is defined in colorMap
        
        if searchColors {
            if let colorFound = self.searchColorMap(rgbColors) {
                return colorFound
            }
        }
        
        let colors: Array = rgbColors.components(separatedBy: ",")
        
        if colors.count == 1 || colors.count == 2 {
            
            let alpha = Float(colors.count == 2 ? Float(colors[1]) ?? 1 : 1) 
            
            return self.hexStringToUIColor(rgbString: colors[0], alpha: alpha)
            
        } else if colors.count == 4 {
            if let red = Float(colors[0]), let green = Float(colors[1]), let blue = Float(colors[2]), let alpha = Float(colors[3]) {
                
                if (red >= 0 && red < 256) && (green >= 0 && green < 256) && (blue >= 0 && blue < 256) && (alpha >= 0 && alpha <= 1) {
                    return UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: CGFloat(alpha))
                }
            }
        }
        
        return nil
    }
    
    /**
     hexStringToUIColor convert hex to uicolor
     
     - parameters:
     rgbString: rgb string value
     
     - returns:    UIColor
     */
    
    func hexStringToUIColor (rgbString:String, alpha: Float) -> UIColor {
        var hex = rgbString.replacingOccurrences(of: "#", with: "")
        hex = hex.replacingOccurrences(of: "0x", with: "")
        
        let cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if ((cString.count) != 6) {
            return UIColor.red
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    /**
     searchColorMap search colors in array to map
     
     - parameters:
     colorName: name of the color from colors arrat
     
     - returns:    UIColor
     */
    
    func searchColorMap(_ colorName: String) -> UIColor? {
        let appearanceModels = AppearanceController.sharedInstance.appearanceModels
        
		let colors = appearanceModels.compactMap { $0.colors }.flatMap { $0 }
		let color = colors.filter { $0.name == colorName }.last
        
        if let value = color?.value {
            return self.convertToUIColor(value, searchColors: false)
        }
        
        return nil
    }
    
    /**
     convertToUIEdgeInsets convert validated edgeInsets values
     to UIEdgeInsets object.
     
     - parameters:
     - edgeInsets: validate "top,left,bottom,right" format
     
     - returns:    UIEdgeInsets
     */
    
    func convertToUIEdgeInsets(_ edgeInsets: String) -> UIEdgeInsets? {
        
        let values: Array = edgeInsets.components(separatedBy: ",")
        
        if values.count != 4 { return nil }
        
        guard let top = Float(values[0]), let left = Float(values[1]), let bottom = Float(values[2]), let right = Float(values[3]) else {
            return nil
        }
        
        if top > 0 && left > 0 && bottom > 0 && right > 0 {
            return UIEdgeInsets.init(top: CGFloat(top), left: CGFloat(left), bottom: CGFloat(bottom), right: CGFloat(right))
        } else {
            return nil
        }
    }
    
    /**
     buttonControlState returns UIControlState of string represantation.
     
     - parameters:
     - state: string of state
     
     - returns:    UIControlState
     */
    
    func buttonControlState(_ state: String?) -> UIControl.State {
        
        var controlState: UIControl.State
        
        guard let state = state else {
            return UIControl.State()
        }
        
        switch state.lowercased() {
        case "normal": controlState = UIControl.State(); break
        case "highlighted": controlState = UIControl.State.highlighted; break
        case "disabled": controlState = UIControl.State.disabled; break
        case "selected": controlState = UIControl.State.selected; break
        default: controlState = UIControl.State()
        }
        
        return controlState
    }
    
    /**
     textAlignment returns UIControlState of string represantation.
     
     - parameters:
     - alignmentString: string of aligment
     
     - returns:    UIControlState
     */
    
    func textAlignment(_ alignmentString: String?) -> NSTextAlignment {
        
        var alignment: NSTextAlignment
        
        guard let alignmentString = alignmentString else {
            return NSTextAlignment.left
        }
        
        switch alignmentString.lowercased() {
        case "left": alignment = NSTextAlignment.left; break
        case "right": alignment = NSTextAlignment.right; break
        case "center": alignment = NSTextAlignment.center; break
        case "justified": alignment = NSTextAlignment.justified; break
        case "natural": alignment = NSTextAlignment.natural; break
        default: alignment = NSTextAlignment.left
        }
        
        return alignment
    }
    
    /**
     lineBreakMode returns NSLineBreakMode of string representation.
     
     - parameters:
     - lineBreakString: string with an integer representing the line break mode
     
     - returns:    NSLineBreakMode
     */
    
    func lineBreakMode(_ lineBreakString: String?) -> NSLineBreakMode {
        
        guard let lineBreakString = lineBreakString, let lineBreakInt = Int(lineBreakString), let breakMode = NSLineBreakMode.init(rawValue: lineBreakInt) else {
            return NSLineBreakMode.byWordWrapping
        }
        
        return breakMode
    }
    
    
    /**
     loadFile loads custom json styles from file.
     
     - parameters:
     - fileName:
     - completion:
     */
    
    func loadFile(_ fileName: String) throws -> String {
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            throw NSError(domain: "com.FuzFuz", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid filename!"])
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.alwaysMapped)
        
        guard let dataString = String(data: data, encoding: String.Encoding.utf8) else {
            throw NSError(domain: "com.FuzFuz", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid contents!"])
        }
        
        return dataString
    }
}

