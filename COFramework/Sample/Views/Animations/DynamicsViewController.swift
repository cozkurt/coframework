//
//  DynamicsViewController.swift
//  COPrototype
//
//  Created by cenker on 7/1/16.
//  Copyright © 2016 Cenker Ozkurt. All rights reserved.
//

import UIKit

class DynamicsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GRADIENT_ANIMATION_EVENT"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func behaviour1(sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BEHAVIOR_1_EVENT"), object: nil)
    }
    
    @IBAction func behaviour2(sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BEHAVIOR_2_EVENT"), object: nil)
    }
    
    @IBAction func behaviour3(sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BEHAVIOR_3_EVENT"), object: nil)
    }
    
    @IBAction func behaviour4(sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BEHAVIOR_4_EVENT"), object: nil)
    }
    
}
