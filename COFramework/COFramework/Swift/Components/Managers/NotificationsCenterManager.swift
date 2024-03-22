//
//  NotificationsCenterManager.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation

public class NotificationsCenterManager {
    
    public typealias FlowInstanceNameCallBack = (() -> (name: String?, value: String?))
    
    /// callback method to add new userInfo value
    public var flowInstanceNameCallBack: FlowInstanceNameCallBack? = nil
    
    /// Store each NotificationsCenter object
    /// [className: [(forName, notification)]
    var notifObjects:[String: [(String, NSObjectProtocol)]] = [:]
    
    //
    // MARK: - sharedInstance for singleton access
    //
    public static let sharedInstance: NotificationsCenterManager = NotificationsCenterManager()
    
    // MARK: - Init Methods
    
    // Prevent others from using the default '()' initializer for this class.
    fileprivate init() {}
    
    //NotificationsController.sharedInstance.post("DISMISS")
    
    /**
     post notification
     
     - parameters:
     - return : Void
     */
    public func post(_ forName: String, object: Any? = nil, userInfo: [AnyHashable: Any]? = [:], delay: TimeInterval = 0) {

        runOnMainQueue(after: delay) {
            
            if var userInfo = userInfo, let flowInstanceNameCallBack = self.flowInstanceNameCallBack {
                let result = flowInstanceNameCallBack()
                
                if let name = result.name, let value = result.value {
                    userInfo[name] = value
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: forName), object: object, userInfo: userInfo)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: forName), object: object, userInfo: userInfo)
            }
        }
    }
    
    /**
     addObserver stores observer information to release later
     
     - parameters:
     - return : Void
     */
    public func addObserver(_ object: AnyHashable, forName: String, _ observe: @escaping (Foundation.Notification) -> Void) {
        
        let name = object.description.split(":").first ?? object.description
        let notif = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: forName), object: nil, queue: nil, using: observe)
        
        if let notifications = self.notifObjects[name] {
            
            // this code specially to multiple instances of
            // cells registering same observer
            // search if notif already registered
            
            for n in notifications {
                if n.0 == forName {
                    self.notifObjects[name]?.removeAll()
                }
            }
        } else {
            self.notifObjects[name] = []
        }
        
        self.notifObjects[name]?.append((forName, notif))
    }
    
    /**
     removeObserver removes observer information stored previosly
     
     - parameters:
     - return : Void
     */
    public func removeObserver(_ object: AnyHashable) {
        
        let name = object.description.split(":").first ?? object.description
        
        guard let observers = self.notifObjects[name] else {
            return
        }
        
        for observer in observers {
            NotificationCenter.default.removeObserver(observer.1)
        }
        
        self.notifObjects[name]?.removeAll()
        self.notifObjects[name] = nil
    }
}
