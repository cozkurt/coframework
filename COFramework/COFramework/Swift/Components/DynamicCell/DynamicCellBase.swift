//
//  DynamicCellBase.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

public class DynamicCellBase: UITableViewCell {

    @IBOutlet var top: NSLayoutConstraint!
    @IBOutlet var left: NSLayoutConstraint!
    @IBOutlet var right: NSLayoutConstraint!
    @IBOutlet var bottom: NSLayoutConstraint!
    
    // Cell with content, this view will be used to adf cornerRadius
    @IBOutlet var dynamicCellSubView: UIView?
    
    // Space after dynamicCellSubView view, space will be added after this view
    var space:CGFloat = 5.0
    
    public override func awakeFromNib() {
        super.awakeFromNib()

        if self.dynamicCellSubView?.constraints.count ?? 0 > 0 {
            self.top?.constant = space / 2
            self.left?.constant = space
            self.right?.constant = space
            self.bottom?.constant = space / 2
        } else {
            self.dynamicCellSubView?.frame = CGRect(x: (self.frame.origin.x + space), y: (self.frame.origin.y + space / 2), width: (self.frame.size.width - space * 2), height: (self.frame.size.height - space))
        }
        
        self.dynamicCellSubView?.layer.cornerRadius = 12
        self.dynamicCellSubView?.layer.borderWidth = 1
        self.dynamicCellSubView?.layer.borderColor = UIColor.systemGray2.withAlphaComponent(0.6).cgColor
        
        self.dynamicCellSubView?.layoutIfNeeded()
    }
}
