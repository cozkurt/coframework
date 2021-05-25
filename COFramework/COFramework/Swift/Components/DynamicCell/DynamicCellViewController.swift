//
//  DynamicCellViewController.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

public class DynamicCellViewController: DynamicActionSheet {

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        DynamicCellController.sharedInstance.dynamicCellViewController = self
        
        self.addTapGesture()
    }
    
    func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissView))
        self.blurView.addGestureRecognizer(tapGestureRecognizer)
        self.blurView.isUserInteractionEnabled = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // configure keyboard only for editing
        // we need to regiester eveytime view apprears
        // because it will be emoved in AppTableBase when
        // view disappears
        
        self.keyboardConfigure()
    }
    
    @IBAction func dismissView() {
        if DynamicCellController.sharedInstance.tapToDismiss {
            DynamicCellController.sharedInstance.dismissViewController()
        }
    }
}
