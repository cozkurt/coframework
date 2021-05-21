//
//  SignalData.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/14/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import Foundation

class SignalData<T> {
    
    typealias completed = ((T?) -> Void)
    
    var value : T? {
        didSet {
            self.notify(value)
        }
    }
    
    private var listeners = [String: completed]()
    
    convenience init(_ value: T?) {
        self.init()
        self.value = value
    }
    
    public func bind(_ object: AnyObject, completed: @escaping completed) {
        if let name = object.description.split(":").first ?? object.description {
            listeners[name] = completed
        }
    }
    
    public func notify(_ data: T?) {
        listeners.forEach({ $0.value(data) })
    }
    
    deinit {
        listeners.removeAll()
    }
}
