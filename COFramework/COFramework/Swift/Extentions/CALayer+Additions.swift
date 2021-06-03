//
//  CALayer+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit
import Foundation

extension CALayer {
    public var borderUIColor: UIColor {
		set {
			self.borderColor = newValue.cgColor
		}
		
		get {
			return UIColor(cgColor: self.borderColor!)
		}
	}
}
