//
//  UIButton+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//


import UIKit

extension UIButton {
    func scaleButtonTitle() {
        self.titleLabel?.minimumScaleFactor = 0.5
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func sizeToFitWidth(contentInset: CGFloat = 40) {
        if let fontName = self.titleLabel?.font.fontName, let size = self.titleLabel?.font.pointSize, let font = UIFont(name: fontName, size: size)  {
            let frameWidth = self.frame.width

            if let width = self.titleLabel?.text?.size(withAttributes: [NSAttributedString.Key.font: font]).width {
                self.frame.size = CGSize(width: width + contentInset, height:  self.frame.size.height)
                
                let adjustedX = self.frame.origin.x + (frameWidth - (width + contentInset)) / 2
                self.frame.origin = CGPoint(x: adjustedX, y: self.frame.origin.y)
            }
        }
    }
}
