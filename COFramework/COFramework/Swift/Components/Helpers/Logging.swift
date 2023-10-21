//
//  Logging.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/7/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit
import Foundation

public protocol LoggerDelegate {
    func loggerUpdated()
}

public enum LogLevel: Int {
    case debug
    case info
    case warning
    case error
    case custom
    case none
}

public class Logger {
    
    /// eventBuffer limit per action
    static let maxEventsBufferSize = 50
    
    /// hold all events in memory
    open var logBuffer: [String] = [""]
    
    /// logLevel
    open var logLevel: LogLevel
    
    /// logDetails
    open var logDetails: Bool = true
    
    /// Logger Delegate
    open var delegate: LoggerDelegate?
    
    // MARK: - sharedInstance for singleton access
    public static let sharedInstance: Logger = Logger()
    
    // MARK: - Init Methods
    
    public init() {
        self.logBuffer = []
        self.logLevel = .debug
    }
    
    // MARK: - Clear logs
    
    public func clearLogs() {
        self.logBuffer.removeAll()
        
        if let delegate = delegate {
            delegate.loggerUpdated()
        }
    }
    
    // MARK: - Log Methods
    
    public func LogDebug(_ msg:String, function: String = #function, file: String = #file, line: Int = #line) {
        if UIDevice.isSimulator || UIDevice().isMac() {
            if self.logLevel.rawValue <= LogLevel.debug.rawValue {
                print("[DEBUG] \(makeTag(function, file: file, line: line, msg: msg))")
            }
        }
    }
    
    public func LogInfo(_ msg:String, function: String = #function, file: String = #file, line: Int = #line) {
        if UIDevice.isSimulator || UIDevice().isMac() {
            if self.logLevel.rawValue <= LogLevel.info.rawValue {
                print("[INFO] \(makeTag(function, file: file, line: line, msg: msg))")
            }
        }
    }
    
    public func LogWarning(_ msg:String, function: String = #function, file: String = #file, line: Int = #line) {
        if UIDevice.isSimulator || UIDevice().isMac() {
            if self.logLevel.rawValue <= LogLevel.warning.rawValue {
                print("[WARNING] \(makeTag(function, file: file, line: line, msg: msg))")
            }
        }
    }
    
    public func LogError(_ msg:String, function: String = #function, file: String = #file, line: Int = #line) {
        if UIDevice.isSimulator || UIDevice().isMac() {
            if self.logLevel.rawValue <= LogLevel.error.rawValue {
                print("[ERROR] \(makeTag(function, file: file, line: line, msg: msg))")
            }
        }
    }
    
    public func LogCustom(_ msg:String, function: String = #function, file: String = #file, line: Int = #line) {
        if UIDevice.isSimulator || UIDevice().isMac() {
            if self.logLevel.rawValue == LogLevel.custom.rawValue {
                print("[CUSTOM] \(makeTag(function, file: file, line: line, msg: msg))")
            }
        }
    }
    
    fileprivate func makeTag(_ function: String, file: String, line: Int, msg: String) -> String {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        let timeString = formatter.string(from: Date())

        var logString = ""
        
        if self.logDetails {
            let url = URL(fileURLWithPath: file)
            let className = url.lastPathComponent
            logString = "\(timeString): \(className) \(function)[\(line) : \(msg)]"
        } else {
            logString = "\(msg)"
        }

        // remove oldest log if bufferSize reached
        if self.logBuffer.count >= Logger.maxEventsBufferSize && self.logBuffer.count > 0 {
            self.logBuffer.remove(at: 0)
        }
        
        // append to buffer size
        self.logBuffer.append(logString)
        
        if let delegate = delegate {
            delegate.loggerUpdated()
        }
        
        return logString
    }
}
