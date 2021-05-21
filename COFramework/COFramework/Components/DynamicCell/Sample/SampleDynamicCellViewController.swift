//
//  SampleDynamicCellViewController.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

class SampleDynamicCellViewController: DynamicActionSheet {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollToDismiss = false

//        let _ = DynamicCellController.sharedInstance.cellEditingNotification { (editingStyle, cellNibName, indexPath) in
//            DynamicCellController.sharedInstance.dismissCell(DynamicCellKey.init(rawValue: cellNibName) ?? .searchResultCell)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DismissButton.sharedInstance.presentButton(toView: self.view, iconName: "x.circle", delay: 0) {
            NotificationsCenterManager.sharedInstance.post("DISMISS")
        }
    }
    
    @IBAction func add1() {
        DynamicCellController.sharedInstance.postCell(self, key: "SearchResultCell", trailingActions: "Delete".localize(), once: false, only: false)
    }
    
    @IBAction func remove1() {
        DynamicCellController.sharedInstance.dismissCell("SearchResultCell")
    }
    
    @IBAction func add2() {
        DynamicCellController.sharedInstance.postCell(self, key: "GeoLocationCell", trailingActions: "Delete".localize(), once: false, only: false)
    }
    
    @IBAction func remove2() {
        DynamicCellController.sharedInstance.dismissCell("GeoLocationCell")
    }
}
