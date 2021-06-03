//
//  UISegmentedControl+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    
    public func defaultConfiguration(font: UIFont, color: UIColor) {
        let defaultAttributes: [NSAttributedString.Key: Any]? = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }
    
    public func selectedConfiguration(font: UIFont, color: UIColor) {
        let selectedAttributes: [NSAttributedString.Key: Any]? = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
    
    public func removeDividers() {
        setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    public func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    public func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
