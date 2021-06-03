//
//  Data+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation

extension Data {
    public var hexString: String {
        return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
    
    public var toString: String {
        return map { String($0) }.joined()
    }
}
