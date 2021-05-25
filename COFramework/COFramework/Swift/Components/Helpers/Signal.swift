//
//  Signal.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 11/16/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import Foundation

open class Signal {
    
    public typealias completed = (() -> Void)
    
    private var listeners = [String: completed]()
        
    public func bind(_ object: AnyObject, completed: @escaping completed) {
        if let name = object.description.split(":").first ?? object.description {
            listeners[name] = completed
        }
    }
    
    public func notify() {
        listeners.forEach({ $0.value() })
    }
    
    deinit {
        listeners.removeAll()
    }
}
