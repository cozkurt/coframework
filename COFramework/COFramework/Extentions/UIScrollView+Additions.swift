//
//  UIScrollView+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

extension UIScrollView {
	
	@objc var isAtTop: Bool {
		return contentOffset.y <= verticalOffsetForTop
	}
	
	@objc var isAtBottom: Bool {
		return contentOffset.y >= verticalOffsetForBottom
	}
	
	@objc var verticalOffsetForTop: CGFloat {
		let topInset = contentInset.top
		return -topInset
	}
	
	@objc var verticalOffsetForBottom: CGFloat {
		let scrollViewHeight = bounds.height
		let scrollContentSizeHeight = contentSize.height
		let bottomInset = contentInset.bottom
		let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
		return scrollViewBottomOffset
	}
	
}
