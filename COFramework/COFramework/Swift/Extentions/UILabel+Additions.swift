//
//  UILabel+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//


import UIKit

extension UILabel {
    
    func sizeToFitHeight() {
        let size: CGSize = self.sizeThatFits(CGSize.init(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        var frame:CGRect = self.frame
        frame.size.height = size.height
        self.frame = frame
        return
    }
	
	func sizeToFitWidth() {
		self.sizeToFitWidth(contentInset: 0)
	}

	@objc func setTextWhileKeepingAttributes(_ string: String) {
		if let newAttributedText = self.attributedText {
			let mutableAttributedText = newAttributedText.mutableCopy()
			(mutableAttributedText as AnyObject).mutableString.setString(string)
			self.attributedText = mutableAttributedText as? NSAttributedString
		}
	}
    
    func addCharactersSpacing(_ value: CGFloat = 1.15) {
        if let textString = text {
            let attrs: [NSAttributedString.Key : Any] = [.kern: value]
            attributedText = NSAttributedString(string: textString, attributes: attrs)
        }
    }
    
    func applyLineSpacingToLabel(_ spacing: CGFloat = 1.4, _ text: String) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        style.alignment = .center
        let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : self.font, NSAttributedString.Key.foregroundColor : self.textColor ]
        self.attributedText = NSAttributedString(string: text, attributes:attributes as [NSAttributedString.Key : Any])
    }
	
	func sizeToFitWidth(contentInset: CGFloat = 40) {
		let size = self.font.pointSize
		let fontName = self.font.fontName
		
		if let font = UIFont(name: fontName, size: size) {
			let frameWidth = self.frame.width
			
			if let width = self.text?.size(withAttributes: [NSAttributedString.Key.font: font]).width {
				self.frame.size = CGSize(width: width + contentInset, height:  self.frame.size.height)
				
				let adjustedX = self.frame.origin.x + (frameWidth - (width + contentInset)) / 2
				
				self.frame.origin = CGPoint(x: adjustedX, y: self.frame.origin.y)
			}
		}
	}
	
    func sizeToFitWidth(contentInset: CGFloat = 40, leftView: UIView) {
        let size = self.font.pointSize
        let fontName = self.font.fontName
        
        if let font = UIFont(name: fontName, size: size) {
            let frameWidth = self.frame.width
            
            if let width = self.text?.size(withAttributes: [NSAttributedString.Key.font: font]).width {
                self.frame.size = CGSize(width: width + contentInset, height:  self.frame.size.height)
                
                let adjustedX = self.frame.origin.x + (frameWidth - (width + contentInset)) / 2
                let adjustedXView = leftView.frame.origin.x + (frameWidth - (width + contentInset)) / 2
                
                self.frame.origin = CGPoint(x: adjustedX, y: self.frame.origin.y)
                leftView.frame.origin = CGPoint(x: adjustedXView, y: leftView.frame.origin.y)
            }
        }
    }
}
