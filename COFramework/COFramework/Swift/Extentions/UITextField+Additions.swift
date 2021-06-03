//
//  UITextField+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

extension UITextField {
    
    public func reloadReturnKeyType() {
        reloadInputViews()
        
        // NOTE: workaround to properly reload new returnKeyType
        
        let currentText = self.text ?? ""
        text = currentText + " "
        text = currentText
    }
    
    public func validateNewEntry(string:String, validRange:ClosedRange<Int>) -> Bool {
        
        let length = string.count
        
        //If user is deleting we should always allow it
        if (length < self.text?.count ?? 0) {
            return true
        }
        
        //Check if entry length is within valid range
        guard validRange.contains(length) else {
            return false }
        
        let trimmedName = string.trimmingCharacters(in: .whitespaces)
        
        if trimmedName == "" {
            return false
        }
        
        return string.hasValidCharacters
    }
}
