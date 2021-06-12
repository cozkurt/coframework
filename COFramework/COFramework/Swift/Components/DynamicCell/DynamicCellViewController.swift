//
//  DynamicCellViewController.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

open class DynamicCellViewController: DynamicActionSheet {

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        DynamicCellController.sharedInstance.dynamicCellViewController = self
        
        self.addTapGesture()
    }
    
    open func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissView))
        self.blurView.addGestureRecognizer(tapGestureRecognizer)
        self.blurView.isUserInteractionEnabled = true
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // configure keyboard only for editing
        // we need to regiester eveytime view apprears
        // because it will be emoved in AppTableBase when
        // view disappears
        
        self.keyboardConfigure()
    }
    
    @IBAction open func dismissView() {
        if DynamicCellController.sharedInstance.tapToDismiss {
            DynamicCellController.sharedInstance.dismissViewController()
        }
    }
}
