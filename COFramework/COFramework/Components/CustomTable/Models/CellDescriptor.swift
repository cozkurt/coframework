//
//  CellDescriptor.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import Foundation
import ObjectMapper

public typealias ValueClosure = (_ cellDesc: CellDescriptor, _ rowData: NSDictionary, _ index: Int) -> (String, String)?

public struct CellDescriptor: Mappable {
    
    public var cellName: String?
    public var cellIdentifier: String?
    public var cellNibName: String?
    public var cellSelectionStyle: String?
    public var cellData: [AnyObject]?
    public var cellHidden: Bool?
    public var cellCache: Bool?
    public var cellRemoveSeperator: Bool = true
    
    // cell swipe actions exp: delete, remove etc.
    public var cellTrailingActions: String?
    public var cellLeadingActions: String?
    
    // selected row index and any object passed to callback
    // this is used for when cell clicked
    
    public var cellCallback: ((Int?, AnyObject?) -> ())?
    
    // MARK: following keys will be used for multiple/single cells only
    
    /// Sets cells title calculation via closure function
    public var cellValueClosure: ValueClosure?
    
    /// Flags for each cell if they selected
    public var cellSelectedDict: Dictionary<String, Bool> = [:]
    
    // MARK: Mappable protocol conformance
    public init?(map: Map) {
        cellName <- map["cellName"]
        cellIdentifier <- map["cellIdentifier"]
        cellNibName <- map["cellNibName"]
        cellSelectionStyle <- map["cellSelectionStyle"]
        cellData <- map["cellData"]
        cellHidden <- map["cellHidden"]
        cellCache <- map["cellCache"]
        cellRemoveSeperator <- map["cellRemoveSeperator"]
        cellTrailingActions <- map["cellTrailingActions"]
        cellLeadingActions <- map["cellLeadingActions"]
        cellCallback <- map["cellCallback"]
    }
    
    public init(cellName: String?, cellIdentifier: String?, cellNibName: String?, cellSelectionStyle: String?, cellData: [AnyObject]?, cellHidden: Bool?, cellCache: Bool?, cellRemoveSeperator: Bool = false, cellLeadingActions: String? = nil, cellTrailingActions: String? = nil, cellCallback: ((Int?, AnyObject?) -> ())? = nil) {
        
        self.cellName = cellName
        self.cellIdentifier = cellIdentifier
        self.cellNibName = cellNibName
        self.cellSelectionStyle = cellSelectionStyle
        self.cellData = cellData
        self.cellHidden = cellHidden
        self.cellCache = cellCache
        self.cellRemoveSeperator = cellRemoveSeperator
        self.cellTrailingActions = cellTrailingActions
        self.cellLeadingActions = cellLeadingActions
        self.cellCallback = cellCallback
    }
    
    public init(cellName: String?) {
        self.cellName = cellName
        
        self.cellIdentifier = cellName
        self.cellNibName = cellName
        self.cellSelectionStyle = "none"
        self.cellData = nil
        self.cellCache = false
        self.cellRemoveSeperator = false
        self.cellTrailingActions = nil
        self.cellLeadingActions = nil
        self.cellCallback = nil
    }
    
    public func mapping(map: Map) {
        // Mapping already completed in init()
    }
}
