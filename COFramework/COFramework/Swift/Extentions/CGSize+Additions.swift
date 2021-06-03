//
//  CGSize+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

extension CGSize {

    public static func maxSize(_ size: CGSize, _ sizes: CGSize...) -> CGSize {
        return sizes.reduce(size) { maxSize, current in
            return CGSize(width: max(maxSize.width, current.width),
                height: max(maxSize.height, current.height))
        }
    }

    public func aspectFit(_ boundingSize: CGSize) -> CGSize {
        let scaleRatio =
            CGPoint(x: boundingSize.width > 0 ? width / boundingSize.width : 0,
                y: boundingSize.height > 0 ? height / boundingSize.height : 0)
        let scaleFactor = max(scaleRatio.x, scaleRatio.y)
        return CGSize(width: scaleRatio.x * boundingSize.width / scaleFactor,
            height: scaleRatio.y * boundingSize.height / scaleFactor)
    }
}
