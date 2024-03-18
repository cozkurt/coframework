//
//  CellDescriptor.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import Foundation

public typealias ValueClosure = (_ cellDesc: CellDescriptor, _ rowData: [String: Any], _ index: Int) -> (String, String)?

public struct CellDescriptor: Codable {
    
    public var cellName: String?
    public var cellIdentifier: String?
    public var cellNibName: String?
    public var cellSelectionStyle: String?
    public var cellData: [Any]?
    public var cellHidden: Bool?
    public var cellCache: Bool?
    public var cellRemoveSeperator: Bool = true
    
    // cell swipe actions exp: delete, remove etc.
    public var cellTrailingActions: String?
    public var cellLeadingActions: String?
    
    // selected row index and any object passed to callback
    // this is used for when cell clicked
    public var cellCallback: ((Int?, Any?) -> ())?
    
    // MARK: following keys will be used for multiple/single cells only
    
    /// Sets cells title calculation via closure function
    public var cellValueClosure: ValueClosure?
    
    /// Flags for each cell if they selected
    public var cellSelectedDict: [String: Bool] = [:]
    

    // Custom CodingKeys to match the JSON keys with property names, if needed
    private enum CodingKeys: String, CodingKey {
        case cellName, cellIdentifier, cellNibName, cellSelectionStyle, cellHidden, cellCache, cellRemoveSeperator, cellTrailingActions, cellLeadingActions
    }
    
    // Custom initializers can still be used with Codable for additional setup
    public init(cellName: String?, cellIdentifier: String?, cellNibName: String?, cellSelectionStyle: String?, cellData: [Any]?, cellHidden: Bool?, cellCache: Bool?, cellRemoveSeperator: Bool = false, cellLeadingActions: String? = nil, cellTrailingActions: String? = nil, cellCallback: ((Int?, Any?) -> ())? = nil) {
        
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
}
