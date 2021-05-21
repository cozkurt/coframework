//
//  CustomTextField.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 2/29/20.
//  Copyright © 2020 FuzFuz. All rights reserved.
//

import UIKit
import Foundation

open class CustomTextField: AppearanceTextField {
    
    var isEditable: Bool = true
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        
        self.updateBorderColor()
    }
        
    override open func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        self.updateBorderColor()
        
        return true
    }
    
    override open func resignFirstResponder() -> Bool {
        let _ = super.resignFirstResponder()
        self.updateBorderColor()
        
        return true
    }
    
    func updateBorderColor() {
        if isEditable {
            if isFirstResponder {
                self.layer.borderColor = UIColor.systemRed.cgColor
            } else {
                self.layer.borderColor = UIColor.systemGray.cgColor
            }
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
        
        self.applyGradient([UIColor.clear, UIColor.clear ], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0.8, y: 1.0), cornerRadius: 5, opacity: 0.1, animated: false)
    }
}
