//
//  Bundle+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 5/4/20.
//  Copyright © 2020 FuzFuz. All rights reserved.
//

import Foundation

extension Bundle {
    var displayName: String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
}
