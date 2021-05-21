//
//  CGPoint+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

extension CGPoint {
    func intersects(to: CGPoint, delta: CGFloat) -> Bool {
        if abs(self.x - to.x) < delta && abs(self.y - to.y) < delta {
            return true
        } else {
            return false
        }
    }
}
