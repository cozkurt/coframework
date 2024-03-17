//
//  CustomTableBase.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit

/*
 *  MARK: - Section/Cell configuration methods
 */
extension CustomTableBase {
    
    /*
     *  MARK: - Section methods
     */
    
    /**
     focusToCell focus to giving cell
     
     - parameter cellName: cell to focus
     - returns
     */
    
    public func focusToCell(cell: UITableViewCell, animated: Bool) {
        self.tableView?.scrollRectToVisible(cell.frame, animated: animated)
    }
    
    /**
     focusToCell focus to giving cellName
     
     - parameter cellName: cellName to focus
     - returns
     */
    
    public func focusToCell(cellName: String, animated: Bool) {
        if let (section, row) = self.findCellIndex(CellDescriptor(cellName: cellName)) {
            
            self.tableView?.scrollToRow(at: IndexPath(row: row, section: section), at: .bottom, animated: animated)
        }
    }
    
    /**
     expandSection expends giving CellDescriptor
     
     - parameter cellName: CellDescriptor cellname
     - returns
     */
    
    public func expandSection(cellName: String, expanded: Bool) {
        
        guard let (section, _) = self.findCellIndex(CellDescriptor(cellName: cellName)) else {
            return
        }
        
        sectionDescriptors[section].sectionExpanded = expanded
        
        self.tableView?.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    /**
     isSectionExpanded checks if section expanded
     
     - parameter cell: CellDescriptor model's section will be expended
     - returns
     */
    
    public func isSectionExpanded(cellName: String) -> Bool? {
        
        guard let (section, _) = self.findCellIndex(CellDescriptor(cellName: cellName)), let sectionExpanded = sectionDescriptors[section].sectionExpanded else {
            return nil
        }
        
        return sectionExpanded
    }
    
    /**
     addSection adds new section to the end of the table
     
     - parameter item: SectionDescriptor model wil be added
     - returns
     */

    public func addSection(_ item: SectionDescriptor) {
        
        self.sectionDescriptors.append(item)
        
        self.registerCells()
        
        self.tableView?.reloadSections(IndexSet(integer: self.sectionDescriptors.count - 1), with: .automatic)
    }
    
    /**
     insertSection inserts new section to given index
     
     - parameter item: SectionDescriptor model will be added
     - parameter index: of section
     - returns
     */

    public func insertSection(_ item: SectionDescriptor, index: Int) {

        if !(index > 0 && index < self.sectionDescriptors.count) { return }

        self.sectionDescriptors.insert(item, at: index)
        
        self.registerCells()

        self.tableView?.insertSections(IndexSet(integer: index), with: .automatic)
    }
    
    /**
     removeSection removes section to given sectionName
     
     - parameter index: of section
     - returns
     */
    
    public func removeSection(_ sectionName: String) {
        if let sectionIndex = self.findSectionIndex(sectionName) {
            self.removeSection(sectionIndex)
        }
    }
    
    /**
     removeSection removes section to given index
     
     - parameter index: of section
     - returns
     */

    public func removeSection(_ index: Int) {

        if !(index < self.sectionDescriptors.count) { return }

        self.sectionDescriptors.remove(at: index)

        self.tableView?.deleteSections(IndexSet(integer: index), with: .automatic)
    }
    
    /**
     removeSection removes section for given SectionDescriptor model
     
     - parameter item: SectionDescriptor model will be removed
     - returns
     */

    public func removeSection(_ item: SectionDescriptor) {
        for row in 0...(self.sectionDescriptors.count - 1) {
            if sectionDescriptors[row].sectionNibName == item.sectionNibName {
                self.removeSection(row)
            }
        }
    }
    
    /*
     *  MARK: - Cell methods
     */
    
    /**
     expandCell expends giving CellDescriptor
     
     - parameter cell: CellDescriptor model will be expended
     - returns
     */
    
    public func expandCell(cellDescriptor: CellDescriptor, hidden: Bool) {
        
        guard let (section, row) = self.findCellIndex(cellDescriptor) else {
            return
        }
        
        if var cells = sectionDescriptors[section].cells {
            cells[row].cellHidden = hidden
            
            sectionDescriptors[section].cells = cells
            
            self.tableView?.reloadData()
        }
    }
    
    /**
     addCellAtSection adds new cell for given sectionName
     
     - parameter cell: CellDescriptor model will be added
     - parameter sectionName: to insert given cell
     - returns
     */
    
    public func addCellAtSection(_ cellName: String, sectionNibName: String?, sectionTitle: String) {
        if let sectionIndex = findSectionIndex(sectionTitle, sectionNibName) {
            self.addCellAtSection(CellDescriptor(cellName: cellName), section: sectionIndex)
        }
    }
    
    /**
     addCellAtSection adds new cell for given sectionName
     
     - parameter cell: CellDescriptor model will be added
     - parameter sectionName: to insert given cell
     - returns
     */
    
    public func addCellAtSection(_ cell: CellDescriptor, sectionNibName: String?, sectionTitle: String) {
        if let sectionIndex = findSectionIndex(sectionTitle, sectionNibName) {
            self.addCellAtSection(cell, section: sectionIndex)
        }
    }
    
    /**
     addCellAtSection adds new cell for given section
     
     - parameter cell: CellDescriptor model will be added
     - parameter section: to insert given cell
     - returns
     */

    public func addCellAtSection(_ cell: CellDescriptor, section: Int, rowIndex: Int? = nil) {

        guard var cells = self.sectionDescriptors[section].cells else {
            print("section : \(section) don't have any data")
            return
        }
        
        if let row = rowIndex {
            cells.insert(cell, at: row)
        } else {
            cells.append(cell)
        }
        
        self.sectionDescriptors[section].cells = cells
        
        // new cells needs to be registered if not loaded from descriptor plist file
        self.registerCells()
        
        if let row = rowIndex {
            self.tableView?.insertRows(at: [IndexPath(row: row, section: section)], with: .automatic)
        } else {
            self.reloadData()
        }
    }
    
    /**
     removeCell removes cell
     
     - parameter cell: CellDescriptor model will be removed
     - parameter indexPath: IndexPath of the cell
     - returns
     */
    
    public func removeCell(_ cellName: String?, _ indexPath: IndexPath?) {
        self.removeCell(CellDescriptor(cellName: cellName), indexPath)
    }
    
    /**
     removeCell removes cell
     
     - parameter cell: CellDescriptor model will be removed
     - returns
     */

    public func removeCell(_ cell: CellDescriptor? = nil, _ indexPath: IndexPath?) {
        
        let section:Int
        let row:Int
        
        if let indexPath =  indexPath {
            section = indexPath.section
            row = indexPath.row
        } else {
            if let cell = cell, let index = self.findCellIndex(cell) {
                section = index.section
                row = index.row
            } else {
                return
            }
        }
        
        guard var cells = self.sectionDescriptors[section].cells else {
            return
        }

        if cells.count > row {
            cells.remove(at: row)
        } else {
            return
        }

        self.sectionDescriptors[section].cells = cells
        
        if cells.count > 0 {
            self.tableView?.deleteRows(at: [IndexPath(row: row, section: section)], with: .automatic)
        } else {
            self.tableView?.reloadData()
        }
    }
    
    /**
     insertDataToCell insert data for the given cellDescriptor.
     
     - parameter cellName: cell name to be converted to CellDescription in the method
     - parameter cellData: array of data will be used to the given cell model
     - returns
     */
    
    public func insertDataToCell(_ cellName: String, cellData: [CustomData]?) {
        let cell = CellDescriptor(cellName: cellName)
        
        self.insertDataToCell(cell, cellData: cellData)
    }
    
    /**
     insertDataToCell insert data for the given cellDescriptor.
     
     - parameter cell: CellDescriptor model will be removed
     - parameter cellData: array of data will be used to the given cell model
     - parameter valueClosure: is Closure func to dynamicly calculate Title of the cell
     - parameter selectedValues: selectedValues will be used to select single or multiple cells for initially
     - returns
     */

    public func insertDataToCell(_ cell: CellDescriptor, cellData: [CustomData]?) {

        guard let (section, row) = self.findCellIndex(cell) else {
            return
        }
        
        guard var cells = self.sectionDescriptors[section].cells,
            let cellData = cellData else {
                return
        }
        
        cells[row].cellData = cellData
        
        self.sectionDescriptors[section].cells = cells
    }
    
    /**
     insertDataToSection insert data for the given section.
     
     - parameter sectionTitle: SectionTitle of the section to look
     - parameter sectionData: array of data will be used to the given section model
     - returns
     */

    public func insertDataToSection(_ sectionTitle: String, sectionData: CustomData?) {

        guard let (section) = self.findSectionIndex(sectionTitle) else {
            return
        }
        
        self.sectionDescriptors[section].sectionData = sectionData
    }
    
    /**
     modifySectionWithCellDecs updated self.sectionDescriptor with given cellDesc
     to be used in this class
     
     - parameter cell: CellDescriptor model will be removed
     - returns
     */

    public func modifySectionWithCellDecs(_ cell: CellDescriptor) {

        guard let (section, row) = self.findCellIndex(cell) else {
            return
        }
        
        guard var cells = self.sectionDescriptors[section].cells else {
            return
        }
        
        cells[row] = cell
        self.sectionDescriptors[section].cells = cells
        
        self.tableView?.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    /**
     findCellIndex is helper class to find section and row for cell
     
     - parameter cell: CellDescriptor model will be searched to find section and row info.
     - returns: (section: Int, row: Int) to be returned
     */

    public func findCellIndex(_ cell: CellDescriptor) -> (section: Int, row: Int)? {

        if self.sectionDescriptors.count == 0{
            return nil
        }
        
        for section in 0...(self.sectionDescriptors.count - 1) {
            guard let cells = self.sectionDescriptors[section].cells else {
                print("section : \(section) has no cells!")
                continue
            }
            
            // check the count
            if cells.count < 1 {
                continue
            }
            
            for row in 0...(cells.count - 1) {
                if cells[row].cellName == cell.cellName {
                    return (section, row)
                }
            }
        }
        
        return nil
    }
    
    /**
     findSectionIndex is helper class to find section index for given sectionName
     
     - parameter sectionTitle: sectionTitle to find sectionIndex.
     - returns: Int? to be returned
     */
    
    public func findSectionIndex(_ sectionTitle: String, _ sectionNibName: String? = nil) -> Int? {
        
        if self.sectionDescriptors.count > 0 {
            for sectionIndex in 0...(self.sectionDescriptors.count - 1) {
                if self.sectionDescriptors[sectionIndex].sectionTitle == sectionTitle {
                    return sectionIndex
                }
            }
        }
        
        // no section found, then we create one
        let section = SectionDescriptor(sectionNibName: sectionNibName,
                                        sectionTitle: sectionTitle,
                                        sectionExpandable: false,
                                        sectionExpanded: true,
                                        sectionHideNoData: false,
                                        sectionHeaderVisible: true,
                                        sectionData: nil,
                                        sectionFooter: nil,
                                        cells: [])
        
        self.sectionDescriptors.append(section)
        
        // needs to be to inserted before reloadSection tableview
        let sectionIndex = max(0, self.sectionDescriptors.count - 1)
        
        return sectionIndex
    }
    
    /**
     sectionHeaderVisible shows/hide section header for given sectionTitle
     
     - parameter sectionTitle: String of sectionTitle
     - parameter visible: Bool
     - returns
     */
    
    public func sectionHeaderVisible(_ sectionTitle: String, visible: Bool) {
        
        guard let section = findSectionIndex(sectionTitle) else {
            return
        }
        
        self.sectionDescriptors[section].sectionHeaderVisible = visible

        self.tableView?.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    /**
     reloadData reload data for tableview
     
     - parameter resetBuffer: optional to reset buffers
     - returns
     */
    
    public func reloadData(_ resetBuffer: Bool = true) {
        if resetBuffer {
            self.resetBuffers()
        }
        
        runOnMainQueue() {
            self.tableView?.reloadData()
        }
    }
    
    /**
     reloadSection reload section
     
     - parameter index: section index
     - parameter animation: animation on/off
     - returns
     */
    
    public func reloadSection(index: Int, animation: Bool? = false) {
        
        let animation = animation ?? false

        if animation {
            self.tableView?.reloadSections([index], with: .automatic)
        } else {
            if let contentOffset = tableView?.contentOffset {
                self.tableView?.setContentOffset(contentOffset, animated: false)
            }
            
            UIView.performWithoutAnimation {
                self.tableView?.reloadSections([index], with: .none)
            }
        }
    }

    /**
     reloadCell reload cell
     
     - parameter cellName: cellName
     - parameter animation: animation on/off
     - returns
     */
    
    public func reloadCell(cellName: String, animation: Bool = false) {
        if let (section, row) = self.findCellIndex(CellDescriptor(cellName: cellName)) {
            self.tableView?.reloadRows(at: [IndexPath(row: row, section: section)], with: animation ? .automatic : .none)
        }
    }
    
    /**
     reloadAndAnimateCells animate cells from original size to new size
     
     - returns
     */
    
    public func reloadAndAnimateCells() {
        runOnMainQueue() {
            self.tableView?.reloadData()
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
        }
    }
    
    /**
     animateCellSizes animate cells from original size to new size
     
     - returns
     */

    public func animateCells() {
        runOnMainQueue() {
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
        }
    }
}
