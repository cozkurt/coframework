//
//  UIFlowBaseView.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

open class UIFlowBaseView: UIView {

    @IBInspectable var fileName: String?
    @IBInspectable var instanceName: String?
    @IBInspectable var startEventName: String?

    fileprivate var flowController: UIFlowController?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.flowController = UIFlowController(parentView: self, fileName: self.fileName, instanceName: self.instanceName, startEventName: self.startEventName)
    }
}
