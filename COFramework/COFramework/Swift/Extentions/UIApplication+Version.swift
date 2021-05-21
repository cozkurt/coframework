//
//  UIApplication+Version.swift
//  Lystit
//
//  Created by Cenker Ozkurt on 5/16/21.
//  Copyright © 2021 FuzFuz. All rights reserved.
//

import UIKit

extension UIApplication {
    @objc var shortVersion: String {
        guard let version =
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            else { return "" }
        return version
    }
    
    @objc var build: String {
        guard let build =
            Bundle.main.infoDictionary?["CFBundleVersion"] as? String
            else { return "" }
        return build
    }
}
