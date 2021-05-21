//
//  GlobalHelpers.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import Foundation

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
    run(after: wait, closure: closure)
}

/**
 Helper method to run the passed closure on the global queue

 - parameter closure: closure to be run
 */
func runInBackground(_ closure: @escaping () -> Void) {
    run(DispatchQueue.global(qos: DispatchQoS.QoSClass.background), closure: closure)
}

/**
Helper method to run syncronized block

- parameter closure: closure to be run
*/
func synchronized(_ lock: Any, closure: () -> ()) {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        closure()
}


