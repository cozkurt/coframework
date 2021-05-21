//
//  UIResponder+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//


import UIKit

extension UIResponder {
	var parentViewController: UIViewController? {
		return (self.next as? UIViewController) ?? self.next?.parentViewController
	}
	
	var className: String {
		return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
	}
	
	var classNameDot: String {
		return self.className + "."
	}
}
