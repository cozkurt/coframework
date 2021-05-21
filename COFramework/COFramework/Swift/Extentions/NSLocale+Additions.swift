//
//  NSLocale+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation

extension NSLocale {
    
    /// Is Device use Turkish language
    
    static func isTurkish() -> Bool {
        return self.preferredLanguages[0].range(of:"tr") != nil
    }
}
