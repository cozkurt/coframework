//
//  StylesViewController.swift
//  Plume
//
//  Created by Cenker Ozkurt on 7/16/18.
//  Copyright © 2018 Plume Design, Inc. All rights reserved.
//

import UIKit


class StylesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        AppearanceController.sharedInstance.loadAppearance("DemoStyle1", view: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DismissButton.sharedInstance.presentButton(toView: self.view, iconName: "x.circle", delay: 0) {
            NotificationsCenterManager.sharedInstance.post("DISMISS")
        }
    }
    
    @IBAction func loadStyle1() {
        AppearanceController.sharedInstance.loadAppearance("DemoStyle1", view: self.view)
    }
    
    @IBAction func loadStyle2() {
        AppearanceController.sharedInstance.loadAppearance("DemoStyle2", view: self.view)
    }
}
