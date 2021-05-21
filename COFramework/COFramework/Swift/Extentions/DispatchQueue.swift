//
//  DispatchQueue.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//


import Foundation

public extension DispatchQueue {
    
    /// Track tokens, also remove them
    /// if re-run blocks
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String = "com.FuzFuz", block:()->Void) {
        
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
    
    /// remove given token if
    /// block needs to be re-run again
    class func remove(token: String) {
        if let index = _onceTracker.firstIndex(of: token) {
            _onceTracker.remove(at: index)
        }
    }
    
    /**
     Helper method to run the passed closure on the specified queue
     
     - parameter queue:   queue on which the closure should be run
     - parameter wait:    wait time before running the closure
     - parameter closure: closure to be run
     */
    func run(_ queue: DispatchQueue = DispatchQueue.main, after wait: TimeInterval? = nil, closure: @escaping () -> Void) {
        
        if let wait = wait {
            queue.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(wait * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
        } else {
            queue.async(execute: closure)
        }
    }
    
    /**
     Helper method to run the passed closure on the main queue, without any wait time
     
     - parameter wait:    wait time before running the closure
     - parameter closure: closure to be run
     */
    func runOnMainQueue(after wait: TimeInterval? = nil, closure: @escaping () -> Void) {
        self.run(after: wait, closure: closure)
    }
}
