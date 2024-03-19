//
//  PlistViewController.swift
//  Sample
//
//  Created by Ozkurt, Cenker on 3/19/24.
//

import UIKit
import COFramework

class PlistViewController: AppTableBase {
        
        override func viewDidLoad() {
                super.viewDidLoad()
        }
        
        // load cells descriptions/configuration
        override func loadConfiguration() {
                loadCellDescriptors("PlistViewController")
        }
}
