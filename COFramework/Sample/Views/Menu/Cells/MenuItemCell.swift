//
//  MenuItemCell.swift
//  Traderonic
//
//  Created by Cenker Ozkurt on 10/8/19.
//  Copyright © 2021 Traderonic. All rights reserved.
//

import UIKit
import COFramework

class MenuItemCell: UICollectionViewCell {

    @IBOutlet var menuItemBadge: AppearanceButton!
    @IBOutlet var menuItemlabel: AppearanceLabel!
    @IBOutlet var menuItemImage: AppearanceImageView!
    
    func configure(menuItem: (String,String), indexPath: IndexPath, menuItemcount: Int) {
        
        let menuTitle = menuItem.0
        let menuIcon = menuItem.1

        menuItemlabel.text = menuTitle
        menuItemImage.image = UIImage(systemName: menuIcon) ?? UIImage(named: menuIcon)
    }
    
    func badge(count: Int = 0, bgColor: UIColor = UIColor.systemRed, textColor: UIColor = UIColor.systemBackground) {
        if count == 0 {
            self.menuItemBadge?.isHidden = true
        } else {
            self.menuItemBadge?.setTitle("\(count)", for: .normal)
            self.menuItemBadge?.isHidden = false
        }
    }
}
