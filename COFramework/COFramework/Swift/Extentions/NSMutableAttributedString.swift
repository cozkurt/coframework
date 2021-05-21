//
//  NSMutableAttributedString.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//
import UIKit
import Foundation

extension NSMutableAttributedString {
    
    public func setAsLink(_ textToFind:String, linkURL:String) -> Bool {
        self.addAttribute(.link, value: linkURL, range: self.mutableString.range(of: textToFind))
        
        return false
    }
    
    public func style(_ alignment: NSTextAlignment?, lineSpacing: CGFloat?, textToFind: String = "") -> Self {
        
        let range = self.mutableString.range(of: textToFind != "" ? textToFind : self.string)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        if let alignment = alignment { paragraphStyle.alignment = alignment }
        if let lineSpacing = lineSpacing { paragraphStyle.lineSpacing = lineSpacing }
        
        addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        
        return self
    }
    
    public func style(_ height: CGFloat?, alignment: NSTextAlignment?, lineSpacing: CGFloat?, textToFind: String = "") -> Self {
        
        let range = self.mutableString.range(of: textToFind != "" ? textToFind : self.string)
        let paragraphStyle = NSMutableParagraphStyle()
        
        if let height = height { paragraphStyle.lineHeightMultiple = height }
        if let alignment = alignment { paragraphStyle.alignment = alignment }
        if let lineSpacing = lineSpacing { paragraphStyle.lineSpacing = lineSpacing }
        
        addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        
        return self
    }
    
    public func font(_ font: UIFont?, textToFind: String = "") -> Self {
        
        let range = self.mutableString.range(of: textToFind != "" ? textToFind : self.string)
        
        if let font = font {
            addAttribute(.font, value: font, range: range)
        }
        
        return self
    }
    
    public func color(_ color: UIColor?, textToFind: String = "") -> Self {
        
        let range = self.mutableString.range(of: textToFind != "" ? textToFind : self.string)
        
        if let color = color {
            addAttribute(.foregroundColor, value: color, range: range)
        }
        
        return self
    }
}

