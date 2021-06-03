//
//  UIScrollView+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

extension UIScrollView {
	
    public var isAtTop: Bool {
		return contentOffset.y <= verticalOffsetForTop
	}
	
    public var isAtBottom: Bool {
		return contentOffset.y >= verticalOffsetForBottom
	}
	
    public var verticalOffsetForTop: CGFloat {
		let topInset = contentInset.top
		return -topInset
	}
	
    public var verticalOffsetForBottom: CGFloat {
		let scrollViewHeight = bounds.height
		let scrollContentSizeHeight = contentSize.height
		let bottomInset = contentInset.bottom
		let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
		return scrollViewBottomOffset
	}
	
}
