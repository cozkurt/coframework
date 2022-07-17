//
//  UIResponder+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//


import UIKit

extension UIResponder {
	public var parentViewController: UIViewController? {
		return (self.next as? UIViewController) ?? self.next?.parentViewController
	}
	
#if targetEnvironment(macCatalyst)
    public override var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
#else
    public var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
#endif
	
    public var classNameDot: String {
		return self.className + "."
	}
}
