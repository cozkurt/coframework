//
//  ConsoleTableViewCell.swift
//  Plume
//
//  Created by cenker on 7/20/16.
//  Copyright © 2016 Plume Design, Inc. All rights reserved.
//

import UIKit

class ConsoleTableViewCell: UITableViewCell {

    @IBOutlet var label:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
