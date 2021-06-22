//
//  UITextview+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

extension UITextView {
    
    public func setTextWhileKeepingAttributes(_ string: String) {
        if let newAttributedText = self.attributedText {
            let mutableAttributedText = newAttributedText.mutableCopy()
            (mutableAttributedText as AnyObject).mutableString.setString(string)
            self.attributedText = mutableAttributedText as? NSAttributedString
        }
    }
    
    public func applySpacingToTextViewAndScroll(_ contentOffset: CGPoint = .zero, spacing: CGFloat, text: String) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : self.font, NSAttributedString.Key.foregroundColor : self.textColor ]
        self.attributedText = NSAttributedString(string: text, attributes:attributes as [NSAttributedString.Key : Any])
        DispatchQueue.main.async {
            self.setContentOffset(contentOffset, animated: false)
        }
    }
    
    public func checkLimits(text: String, range: NSRange, limit: Int, lineFeed: Bool) -> Bool {
        
        // if next line allowed then skio
        if lineFeed == false && text == "\n" {
            self.resignFirstResponder()
            return false
        }
        
        // filter out adult content
        
        // TO DO: Adult content check disabled
        // self.text = AdultContentManager.sharedInstance.filterAdultContent(string: self.text)
        
        // get the current text, or use an empty string if that failed
        let currentText = self.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under limit
        return updatedText.count <= limit
    }
}
