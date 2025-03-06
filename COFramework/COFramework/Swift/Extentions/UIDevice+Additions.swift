//
//  UIDevice+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

extension UIDevice {
    
    public static var isSimulator: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
    
    public var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
	
    public enum ScreenType: String {
        case i35
        case i4
        case i47
        case i55
		case ix  // no home button
        case iPadx // no home button
        case Unknown
    }
    
    public var bounds: CGRect {
        return UIScreen.main.bounds
    }
	
    public var screenType: ScreenType? {
        switch UIScreen.main.nativeBounds.height {
        case 480, 960:
            return .i35
        case 1136:
            return .i4
        case 1334:
            return .i47
        case 1920:
            return .i55
        case 2360, 2388, 2732:
            return .iPadx
        case 1792, 2436, 2532, 2556, 2622, 2688, 2778, 2796, 2868:
			return .ix
        default:
            return nil
        }
    }

    public func isScreen35or4inch() -> Bool {
		return isScreen35inch() || isScreen4inch()
	}
	
    public func isScreen35inch() -> Bool {
        return UIDevice().screenType == .i35
    }
	
    public func isScreen4inch() -> Bool {
        return UIDevice().screenType == .i4
    }
	
    public func isScreen47inch() -> Bool {
        return UIDevice().screenType == .i47
    }
    
    public func isScreen55inch() -> Bool {
        return UIDevice().screenType == .i55
    }
	
    public func isIPhoneX() -> Bool {
		return UIDevice().screenType == .ix
	}
	
    public func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public func isIPadx() -> Bool {
        return UIDevice().screenType == .iPadx
    }
    
    public func isIPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    public func preferredStyle() -> UIAlertController.Style {
        return UIDevice().isIPad() ? .alert : .actionSheet
    }
    
    public func isMac() -> Bool {
        #if targetEnvironment(macCatalyst)
            return true
        #else
            return false
        #endif
    }
    
    public func deviceInfo() -> String {
        if self.isMac() {
            return "Mac"
        } else if self.isIPhone() {
            return "iPhone"
        } else if self.isIPad() {
            return "iPad"
        }
        
        return UIDevice().model
    }
}
