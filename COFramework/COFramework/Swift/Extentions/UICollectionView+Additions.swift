//
//  UICollectionView+Additions.swift
//  Lystit
//
//  Created by Cenker Ozkurt on 5/26/21.
//  Copyright © 2021 FuzFuz. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func hasItemAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfItems(inSection: indexPath.section)
    }
}
