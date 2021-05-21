//
//  SectionDescriptor.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import ObjectMapper

public struct SectionDescriptor: Mappable {
	
	public var sectionNibName: String?
	public var sectionTitle: String?
	public var sectionExpandable: Bool?
	public var sectionExpanded: Bool?
	public var sectionHideNoData: Bool?
	public var sectionHeaderVisible: Bool?
    public var sectionData: AnyObject?
    public var sectionFooter: String?
	public var cells: [CellDescriptor]?
	
	// MARK: Mappable protocol conformance
	
	public init?(map: Map) {
		sectionNibName <- map["sectionNibName"]
		sectionTitle <- map["sectionTitle"]
		sectionExpandable <- map["sectionExpandable"]
		sectionExpanded <- map["sectionExpanded"]
		sectionHideNoData <- map["sectionHideNoData"]
		sectionHeaderVisible <- map["sectionHeaderVisible"]
        sectionData <- map["sectionData"]
        sectionFooter <- map["sectionFooter"]
		cells <- map["cells"]
	}
	
    public init(sectionNibName: String?, sectionTitle: String?, sectionExpandable: Bool?, sectionExpanded: Bool?, sectionHideNoData: Bool?, sectionHeaderVisible: Bool?, sectionData: AnyObject?, sectionFooter: String?, cells: [CellDescriptor]?) {
		
		self.sectionNibName = sectionNibName
		self.sectionTitle = sectionTitle?.localize()
		self.sectionExpandable = sectionExpandable
		self.sectionExpanded = sectionExpanded
		self.sectionHideNoData = sectionHideNoData
		self.sectionHeaderVisible = sectionHeaderVisible
        self.sectionData = sectionData
        self.sectionFooter = sectionFooter
		self.cells = cells
	}
	
	public init(sectionNibName: String?) {
		self.sectionNibName = sectionNibName
	}
	
	public func mapping(map: Map) {
		// Mapping already completed in init()
	}
}
