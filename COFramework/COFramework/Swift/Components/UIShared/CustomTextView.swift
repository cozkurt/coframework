//
//  CustomTextView.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 11/14/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit

public class CustomTextView: AppearanceTextView {
    
    @IBOutlet public var placeHolderLabel: UILabel?
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        
        self.updateBorderColor()
    }
        
    override public func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        self.updateBorderColor()
        
        return true
    }
    
    override public func resignFirstResponder() -> Bool {
        let _ = super.resignFirstResponder()
        self.updateBorderColor()
        
        return true
    }
    
    public func updateBorderColor() {
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
