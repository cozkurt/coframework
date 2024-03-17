//
//  SectionDescriptor.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import Foundation

public struct SectionDescriptor: Codable {
    public var sectionNibName: String?
    public var sectionTitle: String?
    public var sectionExpandable: Bool?
    public var sectionExpanded: Bool?
    public var sectionHideNoData: Bool?
    public var sectionHeaderVisible: Bool?
    public var sectionFooter: String?
    public var cells: [CellDescriptor]?
    public var sectionData: CustomData?

    private enum CodingKeys: String, CodingKey {
        case sectionNibName, sectionTitle, sectionExpandable, sectionExpanded, sectionHideNoData, sectionHeaderVisible, sectionFooter, cells, sectionData
    }

    public init(sectionNibName: String?, sectionTitle: String?, sectionExpandable: Bool?, sectionExpanded: Bool?, sectionHideNoData: Bool?, sectionHeaderVisible: Bool?, sectionData: CustomData?, sectionFooter: String?, cells: [CellDescriptor]?) {
        self.sectionNibName = sectionNibName
        self.sectionTitle = sectionTitle
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
        self.sectionTitle = nil
        self.sectionExpandable = nil
        self.sectionExpanded = nil
        self.sectionHideNoData = nil
        self.sectionHeaderVisible = nil
        self.sectionData = nil
        self.sectionFooter = nil
        self.cells = nil
    }
}
