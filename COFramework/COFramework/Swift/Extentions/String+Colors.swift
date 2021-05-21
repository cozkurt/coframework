//
//  String+Colors.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 4/2/20.
//  Copyright © 2020 FuzFuz. All rights reserved.
//

import UIKit

internal extension String {
    
    var color: UIColor {
        switch self {
            case "systemBlue":
                return UIColor.systemBlue
            case "systemRed":
                return UIColor.systemRed
            case "systemYellow":
                return UIColor.systemYellow
            case "systemGray":
                return UIColor.systemGray
            case "systemGreen":
                return UIColor.systemGreen
            case "systemBackground":
                return UIColor.systemBackground
            case "systemTeal":
                return UIColor.systemTeal
            case "systemPurple":
                return UIColor.systemPurple
            case "systemOrange":
                return UIColor.systemOrange
            default:
                return UIColor.systemRed
        }
    }
}
