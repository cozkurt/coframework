//
//  TableHelper.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

/*
 *  MARK: - FiltersViewController Helper Extention
 */

extension CustomTableBase {
    
    // MARK: Custom Functions
    
    public func loadCellDescriptors(_ fileName: String) {
        
        if let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "plist"), let cells = NSMutableArray(contentsOfFile: path) as? [[String: Any]] {
            
            let mappable = Mapper<SectionDescriptor>()
            
            self.sectionDescriptors = mappable.mapArray(JSONArray: cells)
        } else {
            print("plist can not be loaded!!!")
        }
    }
    
    /**
     registerCells from plist configuration
     
     - parameter
     - returns: void
     */
    
    public func registerCells() -> Void {
        
        if self.sectionDescriptors.count == 0 {
            return
        }
        
        /// loop trough all sections to find cells
        for section in self.sectionDescriptors {
            guard let cells = section.cells else { return }
            
            /// if cells found register their Nibs for tableview
            for cellRow in cells {
                guard let cellIdentifier = cellRow.cellIdentifier, let cellNibName = cellRow.cellNibName else { return }
                
                if let tableView = self.tableView {
                    tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
                }
            }
        }
    }
    
    func cellKey(_ cellIdentifier: String, indexPath: IndexPath) -> String {
        return "\(cellIdentifier)"
    }
    
    /**
     cellFromBuffer get cell from array already stored, otherwise create one
     
     - parameter cellIdentifier: String cell identifier
     - parameter indexPath: indexPath of current cell
     - parameter cellCache: to store in cache or not. Usually for repeating cells we don't want to cache
     - returns: UITableViewCell
     */
    
    func cellFromBuffer(_ cellIdentifier: String, indexPath: IndexPath, cellCache: Bool = true) -> UITableViewCell? {
        
        let key = self.cellKey(cellIdentifier, indexPath: indexPath)
        
        if cellCache {
            if let cell = self.cellBuffer[key] {
                return cell
            }
        }
        
        if let cell = self.tableView?.dequeueReusableCell(withIdentifier: cellIdentifier) {
            
            if cellCache {
                self.cellBuffer[key] = cell
            }
            
            return cell
        }
        
        return nil
    }
    
    /**
     numberOfSections from plist configuration
     
     - parameter
     - returns: Sections count
     */
    
    func numberOfSections() -> Int {
        return self.sectionDescriptors.count
    }
    
    
    /**
     numberOfRowsInSection : find total count for cells
     calculating all "cellCounts" property in "cells" array
     
     - parameter section:  to find total cells
     - returns: Cells Count in the section
     */
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        
        guard let cells = self.sectionDescriptors[section].cells,
            let sectionExpandable = self.sectionDescriptors[section].sectionExpandable,
            let sectionExpanded = self.sectionDescriptors[section].sectionExpanded, !(sectionExpandable && !sectionExpanded) else {
                return 0
        }
        
        var allRowCounts = 0
        
        for cell in cells {
            
            if let cellCount = cell.cellData?.count {
                allRowCounts += cellCount
            } else {
                allRowCounts += self.cellRecordCount(cell: cell, indexPath: IndexPath(row: 0, section: section))
            }
        }
        
        return allRowCounts
    }
    
    /**
     heightForRowAtIndexPath : find height for cell
     
     - parameter indexPath: of the cells
     - returns: void
     */
    
    func heightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        
        if let _ = self.tableView {
            let (cell, _, cellDescriptor) = self.tableCell(forIndexPath: indexPath)
            
            // check if cell already provides it's height
            
            if (cellDescriptor?.cellHidden ?? false) {
                return 0
            }
            
            if let cell = cell as? CustomTableCellHeight, let height = cell.cellHeight() {
                return height
            }
            
            // find if there is table view in the cell
            
            if let tableView:UITableView = (cell.contentView.subviews.filter { $0.isKind(of: UITableView.self) }).first as? UITableView {
                var tableViewHeight = tableView.contentSize.height
                tableViewHeight += cell.contentView.frame.height - tableView.frame.height
                
                return max(cell.contentView.frame.height, tableViewHeight)
            }
            
            // find if there is collection view in the cell
            
            if let collectionView:UICollectionView = (cell.contentView.subviews.filter { $0.isKind(of: UICollectionView.self) }).first as? UICollectionView {
                var collectionViewHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
                collectionViewHeight += cell.contentView.frame.height - collectionView.frame.height
                
                return max(cell.contentView.frame.height, collectionViewHeight)
            }
            
            // find if there is constraints
            
            if cell.contentView.constraints.count > 0 {
                return UITableView.automaticDimension
            } else {
                return cell.frame.height
            }
        }
        
        return 0
    }
    
    /**
     cellModelWithUpdatedIndex calculates what cell dictionary for given
     nsindexpath should return.
     
     - parameter forIndexPath: IndexPath to find cell
     - returns: return CellDescriptor for given indexPath
     */
    
    func cellModelWithUpdatedIndex(forIndexPath indexPath: IndexPath) -> (cellDescriptor: CellDescriptor, cellIndex: Int)? {
        
        guard let cells = self.sectionDescriptors[indexPath.section].cells else { return nil }
        
        var allRowCounts = 0
        
        for row in 0...(cells.count - 1) {
            let cell = cells[row]
            
            if let cellCount = cell.cellData?.count {
                allRowCounts += cellCount
                
                if indexPath.row < allRowCounts {
                    return (cells[row], abs(allRowCounts - indexPath.row - cellCount))
                }
            } else {
                let cellCount = self.cellRecordCount(cell: cell, indexPath: indexPath)
                
                allRowCounts += cellCount
                
                if indexPath.row < allRowCounts {
                    return (cells[row], abs(allRowCounts - indexPath.row - cellCount))
                }
            }
        }
        
        return nil
    }
    
    /**
     cellRecordCount calculates cell if repeated data in cellData exists
     
     - parameter CellDescriptor for given indexPath
     - returns: record count for given cell
     */
    
    func cellRecordCount(cell: CellDescriptor, indexPath: IndexPath) -> Int {
        var cellCount = 1
        
        guard let cellIdentifier = cell.cellNibName else {
            return 1
        }
        
        if let cellObject = cellFromBuffer(cellIdentifier, indexPath: indexPath, cellCache: cell.cellCache ?? true) as? CustomTableDataSource {
            cellCount = cellObject.numberOfRecords()
        }
        
        return cellCount
    }
    
    /**
     tableCell calculates what tableViewCell identifier for given
     nsindexpath should return.
     
     - parameter forIndexPath: IndexPath to find cell
     - returns: calculated Cell for given indexPath
     */
    
    func tableCell(forIndexPath indexPath: IndexPath) -> (cell: UITableViewCell, cellIndex: Int, cellDescriptor: CellDescriptor?) {
        
        guard let (cellDescriptor, cellIndex) = self.cellModelWithUpdatedIndex(forIndexPath: indexPath), let cellIdentifier = cellDescriptor.cellIdentifier else {
            return (UITableViewCell(), 0, nil)
        }
        
        let cellCache = cellDescriptor.cellCache ?? true
        
        if let cell = cellFromBuffer(cellIdentifier, indexPath: indexPath, cellCache: cellCache) {
            
            // this protocol method needs to be called once
            // because of that we need to track if it's already called
            
            if self.isCellInitialized(cellIdentifier, indexPath: indexPath) == false {
                if let cell = cell as? CustomCellInitProtocol {
                    cell.cellInit(forCellDesc: cellDescriptor)
                }
                
                        let key = self.cellKey(cellIdentifier, indexPath: indexPath)
                
                // set cellAwake after all checks
                self.cellInitBuffer.append(key)
            }
            
            // these methods need to be called always
            // because of incase of not cached

            self.updateSelectionStyle(cell, cellDesc: cellDescriptor)
            
            // check cell seperator
            if cellDescriptor.cellRemoveSeperator {
                cell.removeSeparator()
            }
            
            // this method needs to be called
            // for every cellIndex
            
            // need to use cellIndex not indexPath.row
            // because cellIndex is calculated for that cell if more then one cell in
            // same section
            
            if let cell = cell as? CustomTableCellProtocol {
                cell.cellConfigure(forCellDesc: cellDescriptor, forRow: cellIndex)
            }
            
            return (cell, cellIndex, cellDescriptor)
        } else {
            return (UITableViewCell(), 0, nil)
        }
    }
    
    /**
     isCellInitialized checks if cell already initialized
     
     - parameter cellIdentifier: String
     - returns: Bool
     */
    
    func isCellInitialized(_ cellIdentifier: String, indexPath: IndexPath) -> Bool {
        let key = self.cellKey(cellIdentifier, indexPath: indexPath)
        
        return self.cellInitBuffer.contains(key)
    }
        
    /**
     updateSelectionStyle sets UITableViewCellSelectionStyle for given cell
     that's defined as cellSelectionStyle property in cell
     
     - parameter cell: UITableViewCell object
     - parameter cellDesc: cell dictionary
     - returns: void
     */
    
    func updateSelectionStyle(_ cell: UITableViewCell, cellDesc: CellDescriptor) -> Void {
        
        let style: UITableViewCell.SelectionStyle
        
        guard let selectionStyle = cellDesc.cellSelectionStyle else { return }
        
        switch selectionStyle {
        case "none":
            style = UITableViewCell.SelectionStyle.none
            break
        case "blue":
            style = UITableViewCell.SelectionStyle.blue
            break
        case "gray":
            style = UITableViewCell.SelectionStyle.gray
            break
        default:
            style = UITableViewCell.SelectionStyle.default
        }
        
        cell.selectionStyle = style
    }
    
    /**
     headerViewForSection return UIView header
     
     - parameter section: of header
     - returns: UIView? of header
     */
    
    func headerViewForSection(_ section: Int) -> UIView? {
        
        if let sectionHeaderVisible =  self.sectionDescriptors[section].sectionHeaderVisible, !sectionHeaderVisible {
            return nil
        }
        
        guard let sectionNibName = self.sectionDescriptors[section].sectionNibName,
            let sectionExpandable = self.sectionDescriptors[section].sectionExpandable else { return nil }
        
        if let sectionHideNoData = self.sectionDescriptors[section].sectionHideNoData, self.numberOfRowsInSection(section) == 0 && sectionHideNoData == true { return nil }
        
        guard let headerViewArray = Bundle.main.loadNibNamed(sectionNibName, owner: self, options: nil), let headerView = headerViewArray[0] as? UIView else {
            return nil
        }
        
        if sectionExpandable {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomTableBase.handleSectionTap(_:)))
            headerView.tag = section
            headerView.addGestureRecognizer(tapRecognizer)
        }
        
        if let hView = headerView as? CustomHeaderProtocol {
            hView.headerConfigure(self.sectionDescriptors[section], section: section)
        }
        
        return headerView
    }
    
    /**
     heightForHeaderInSection return height of header
     
     - parameter section: for header
     - returns: CGFloat height if header
     */
    
    func heightForHeaderInSection(_ section: Int) -> CGFloat {
        if let sectionHeaderVisible =  self.sectionDescriptors[section].sectionHeaderVisible, !sectionHeaderVisible {
            return 0
        }
        
        guard let sectionNibName = self.sectionDescriptors[section].sectionNibName else { return 0 }
        
        if let sectionHideNoData = self.sectionDescriptors[section].sectionHideNoData, self.numberOfRowsInSection(section) == 0 && sectionHideNoData == true {
            return 0
        }
        
        guard let headerViewArray = Bundle.main.loadNibNamed(sectionNibName, owner: self, options: nil), let headerView = headerViewArray[0] as? UIView else {
            return 0
        }
        
        // find if there is constraints
        
        if headerView.constraints.count > 0 {
            return UITableView.automaticDimension
        } else {
            return headerView.frame.height
        }
    }
    
    /**
     footerViewForSection return UIView header
     
     - parameter section: of footer
     - returns: UIView? of footer
     */
    
    func footerViewForSection(_ section: Int) -> UIView? {
        
        guard let sectionFooter =  self.sectionDescriptors[section].sectionFooter,
            let footerViewArray = Bundle.main.loadNibNamed(sectionFooter, owner: self, options: nil),
            let footerView = footerViewArray[0] as? UIView else {
                
            return nil
        }
        
        return footerView
    }
    
    /**
     heightForFooterInSection return height of header
     
     - parameter section: for footer
     - returns: CGFloat height if footer
     */
    
    func heightForFooterInSection(_ section: Int) -> CGFloat {
        guard let sectionFooter =  self.sectionDescriptors[section].sectionFooter,
            let footerViewArray = Bundle.main.loadNibNamed(sectionFooter, owner: self, options: nil),
            let footerView = footerViewArray[0] as? UIView else {
                
            return 0
        }
        
        // find if there is constraints
        if footerView.constraints.count > 0 {
            return UITableView.automaticDimension
        } else {
            return footerView.frame.height
        }
    }
}
