//
//  UIDevice+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

extension UIDevice {
    
    @objc static var isSimulator: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
    
    @objc var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
	
    enum ScreenType: String {
        case i35
        case i4
        case i47
        case i55
		case ix  // no home button
        case iPadx // no home button
        case Unknown
    }
    
    var bounds: CGRect {
        return UIScreen.main.bounds
    }
	
    var screenType: ScreenType? {
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
		case 1792, 2436, 2532, 2688, 2778:
			return .ix
        default:
            return nil
        }
    }

	func isScreen35or4inch() -> Bool {
		return isScreen35inch() || isScreen4inch()
	}
	
    func isScreen35inch() -> Bool {
        return UIDevice().screenType == .i35
    }
	
    func isScreen4inch() -> Bool {
        return UIDevice().screenType == .i4
    }
	
    func isScreen47inch() -> Bool {
        return UIDevice().screenType == .i47
    }
    
    func isScreen55inch() -> Bool {
        return UIDevice().screenType == .i55
    }
	
	func isIPhoneX() -> Bool {
		return UIDevice().screenType == .ix
	}
	
    func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    func isIPadx() -> Bool {
        return UIDevice().screenType == .iPadx
    }
    
    func isIPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    func preferredStyle() -> UIAlertController.Style {
        return UIDevice().isIPad() ? .alert : .actionSheet
    }
    
    func isMac() -> Bool {
        #if targetEnvironment(macCatalyst)
            return true
        #else
            return false
        #endif
    }
    
    func deviceInfo() -> String {
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
