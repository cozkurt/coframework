//
//  Double+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation

extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    
    func string(_ fractionDigits:Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    func currencyString(_ localeIdentifier: String? = nil) -> String {
        let formatter = NumberFormatter()
    
        if let identifier = localeIdentifier {
            formatter.locale = Locale(identifier: identifier)
        } else {
            formatter.locale = Locale.current
        }
        
        formatter.numberStyle = .currency
        
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
