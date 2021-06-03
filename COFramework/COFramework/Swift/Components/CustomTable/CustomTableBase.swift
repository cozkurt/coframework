//
//  CustomTableBase.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit
import Foundation

public protocol CustomCellInitProtocol {
    func cellInit(forCellDesc cellDesc: CellDescriptor?)
}

public protocol CustomTableCellProtocol {
    func cellConfigure(forCellDesc cellDesc: CellDescriptor?, forRow row: Int)
}

public protocol CustomTableCellHeight {
    func cellHeight() -> CGFloat?
}

public protocol CustomTableDataSource {
    func numberOfRecords() -> Int
}

public protocol CustomHeaderProtocol {
    func headerConfigure(_ sectionDescription: SectionDescriptor, section: Int)
}

public protocol CustomHeaderTapProtocol {
    func headerTapped(_ sectionDescription: SectionDescriptor, section: Int)
}

open class CustomTableBase: UIViewController {
    
    // MARK: IBOutlet Properties
    @IBOutlet weak public var tableView: UITableView!
    
    // MARK: Variables
    
    /// bindable objects to listen
    public static var tableViewCellEditingEvent: SignalData<(String, String, IndexPath)> = SignalData()
    public static var tableViewScrollingUpEvent: SignalData<String> = SignalData()
    public static var tableViewScrollingDownEvent: SignalData<String> = SignalData()
    public static var tableViewCellEndEvent: SignalData<(String)> = SignalData()
    
    /// Section configuration from pList
    public var sectionDescriptors: [SectionDescriptor] = []
    
    /// Buffer registered cells
    public var cellBuffer: [String: UITableViewCell] = [:]
    
    /// check for cell initialization
    public var cellInitBuffer: [String] = []
    
    // MARK: UIViewController Lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // set automatic sizing if cells are supporting constraints
        self.tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.estimatedRowHeight = 44
        
        self.tableView?.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView?.estimatedSectionHeaderHeight = 44
        
        self.configureCells()
    }

    // MARK: Subclass must implement following methods
    
    open func configureCells() {
        // override
        self.loadConfiguration()
        
        // register cells to tableView
        self.registerCells()
    }
    
    // load cells descriptions/configuration
    open func loadConfiguration() {
        // override
    }
    
    public func resetBuffers() {
        // erase tableview cell cache
        self.cellBuffer.removeAll()
        self.cellInitBuffer.removeAll()
    }
}

