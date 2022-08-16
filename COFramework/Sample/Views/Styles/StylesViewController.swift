//
//  StylesViewController.swift
//  Plume
//
//  Created by Cenker Ozkurt on 7/16/18.
//  Copyright © 2018 Plume Design, Inc. All rights reserved.
//

import UIKit
import COFramework

class StylesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loadStyle1() {
        AppearanceController.sharedInstance.loadAppearance("DemoStyle1", view: self.view)
    }
    
    @IBAction func loadStyle2() {
        AppearanceController.sharedInstance.loadAppearance("DemoStyle2", view: self.view)
    }
    
    @IBAction func loadStyle3() {
        AppearanceController.sharedInstance.loadAppearance("DemoStyle3", view: self.view)
    }
    
    @IBAction func loadStyle4() {
        AppearanceController.sharedInstance.loadAppearance("DemoStyle4", view: self.view)
    }
    
    @IBAction func close() {
        NotificationsCenterManager.sharedInstance.post("DISMISS")
    }
}
