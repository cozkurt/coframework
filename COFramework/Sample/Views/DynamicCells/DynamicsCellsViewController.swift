//
//  SampleDynamicCellViewController.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import COFramework

class DynamicsCellsViewController: DynamicActionSheet {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollToDismiss = false
        
        CustomTableBase.tableViewCellEditingEvent.bind(self) { (tuple) in
            guard let indexPath = tuple?.2 else { return }
            
            DynamicCellController.sharedInstance.dismissCell(indexPath)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func add1() {
        DynamicCellController.sharedInstance.postCell(self, key: "BluetoothOnCell", trailingActions: "Delete".localize(), once: false, only: false, tableViewBottomGap: 80, tableViewScrollToBottom: true)
    }
    
    @IBAction func remove1() {
        DynamicCellController.sharedInstance.dismissCell("BluetoothOnCell")
    }
    
    @IBAction func add2() {
        DynamicCellController.sharedInstance.postCell(self, key: "ConnectCell", trailingActions: "Delete".localize(), once: false, only: false, tableViewBottomGap: 80, tableViewScrollToBottom: true)
    }
    
    @IBAction func remove2() {
        DynamicCellController.sharedInstance.dismissCell("ConnectCell")
    }
    
    @IBAction func add3() {
        DynamicCellController.sharedInstance.postCell(self, key: "ConnectPodToModemCell", leadingActions: "Hello", trailingActions: "Delete".localize(), once: false, only: false, tableViewBottomGap: 80, tableViewScrollToBottom: true)
    }
    
    @IBAction func remove3() {
        DynamicCellController.sharedInstance.dismissCell("ConnectPodToModemCell")
    }
}
