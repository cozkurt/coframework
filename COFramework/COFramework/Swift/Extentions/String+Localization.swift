//
//  String+Localization.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 4/2/20.
//  Copyright © 2020 FuzFuz. All rights reserved.
//

import Foundation

extension String {
    
    public func localize() -> String {
        
        let lang = Locale.current.identifier
        
        if let path = Bundle.main.path(forResource: lang, ofType: "lproj"), let bundle = Bundle(path: path) {
            let stringToReturn = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
            return stringToReturn
        }
        
        return self
    }
}
