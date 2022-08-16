//
//  UIApplication+Version.swift
//  Lystit
//
//  Created by Cenker Ozkurt on 5/16/21.
//  Copyright © 2021 FuzFuz. All rights reserved.
//

import UIKit

extension UIApplication {
    public var shortVersion: String {
        guard let version =
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            else { return "" }
        return version
    }
    
    public var build: String {
        guard let build =
            Bundle.main.infoDictionary?["CFBundleVersion"] as? String
            else { return "" }
        return build
    }
    
    public var window: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
}
