//
//  UITableViewCell+CustomTable.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 1/28/20.
//  Copyright © 2020 FuzFuz. All rights reserved.
//

import UIKit
import Foundation

extension UITableViewCell {
    func removeSeparator() {
        self.separatorInset = UIEdgeInsets.init(top: 0, left: 1000, bottom: 0, right: 0)
    }
    
    func hideThisCell(customTableBase: CustomTableBase?) {
        customTableBase?.expandCell(cellDescriptor: CellDescriptor(cellName: self.reuseIdentifier), hidden: true)
    }
    
    func showThisCell(customTableBase: CustomTableBase?) {
        customTableBase?.expandCell(cellDescriptor: CellDescriptor(cellName: self.reuseIdentifier), hidden: false)
    }
    
    func reloadData(customTableBase: CustomTableBase?) {
        customTableBase?.reloadData()
    }
}
