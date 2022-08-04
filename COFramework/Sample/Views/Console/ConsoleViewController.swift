//
//  ConsoleViewController.swift
//  Plume
//
//  Created by cenker on 7/20/16.
//  Copyright © 2016 Plume Design, Inc. All rights reserved.
//

import UIKit
import COFramework

class ConsoleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoggerDelegate {
    
    @IBOutlet var warnButton: UIButton!
    @IBOutlet var infoButton: UIButton!
    @IBOutlet var debugButton: UIButton!
    @IBOutlet var customButton: UIButton!
    @IBOutlet var errorButton: UIButton!
    @IBOutlet var autoScrollLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var clearLogsButton: UIButton!
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var scrollSwitch:UISwitch!
    @IBOutlet var logModeLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 140
        
        self.tableView.register(UINib(nibName: "ConsoleTableViewCell", bundle: nil), forCellReuseIdentifier: "consoleCell")
        
        Logger.sharedInstance.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateLogMode()
        self.scrollToBottom()
        
//        DismissButton.sharedInstance.presentButton(toView: self.view, iconName: "x.circle", delay: 0) {
//            NotificationsCenterManager.sharedInstance.post("DISMISS")
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loggerUpdated() {
        runOnMainQueue {
            self.scrollToBottom()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "consoleCell", for: indexPath) as? ConsoleTableViewCell
        cell?.label?.text = Logger.sharedInstance.logBuffer[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Logger.sharedInstance.logBuffer.count
    }
    
    @objc func scrollToBottom() {
        
        if self.scrollSwitch?.isOn == false {
            return
        }
        
        self.tableView.reloadData()
        
        let numberOfRows = Logger.sharedInstance.logBuffer.count
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows-1, section: 0)
            tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: false)
        }
    }
    
    @objc func updateLogMode() {
        switch  Logger.sharedInstance.logLevel {
        case .debug:
            self.logModeLabel?.text = "Log Mode (debug):"
            break
        case .info:
            self.logModeLabel?.text = "Log Mode (info):"
            break
        case .warning:
            self.logModeLabel?.text = "Log Mode (warn):"
            break
        case .error:
            self.logModeLabel?.text = "Log Mode (error):"
            break
        case .custom:
            self.logModeLabel?.text = "Log Mode (custom):"
            break
        default:
            self.logModeLabel?.text = ""
        }
    }
    
    @IBAction func close() {
        NotificationsCenterManager.sharedInstance.post("DISMISS")
    }
    
    @IBAction func logModeDebug() {
        Logger.sharedInstance.logLevel = .debug
        self.updateLogMode()
    }
    
    @IBAction func logModeInfo() {
        Logger.sharedInstance.logLevel = .info
        self.updateLogMode()
    }
    
    @IBAction func logModeWarning() {
        Logger.sharedInstance.logLevel = .warning
        self.updateLogMode()
    }
    
    @IBAction func logModeError() {
        Logger.sharedInstance.logLevel = .error
        self.updateLogMode()
    }
    
    @IBAction func logModeCustom() {
        Logger.sharedInstance.logLevel = .custom
        self.updateLogMode()
    }
    
    @IBAction func clearLogs() {
        Logger.sharedInstance.clearLogs()
    }
}
