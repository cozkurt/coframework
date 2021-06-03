//
//  NSObject+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//


import Foundation

extension NSObject {
    
    public func synchronized<T>(_ lockObj: Any, closure: () throws -> T) rethrows -> T
    {
        objc_sync_enter(lockObj)
        
        defer {
            objc_sync_exit(lockObj)
        }
        
        return try closure()
    }
}
