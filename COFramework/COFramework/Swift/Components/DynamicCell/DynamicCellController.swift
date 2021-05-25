//
//  DynamicCellController.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

open class DynamicCellController {
    
    // notifiers
    var dynamicCellControllerDataUpdatedEvent: SignalData<[AnyObject]?> = SignalData()
    
    // parent view controller
    var dynamicCellViewController: AppTableBase?
    
    // turn on/off id tapToDismiss needed
    var tapToDismiss: Bool = true
    
    // turn on/off only option
    var only: Bool = false
    
    //
    // MARK: - sharedInstance for singleton access
    //
    public static let sharedInstance: DynamicCellController = DynamicCellController()
    
    // MARK: - Init Methods
    
    // Prevent others from using the default '()' initializer for this class.
    
    /**
     init()
     
     - parameters:
     - return : self
     */
    
    fileprivate init() {}
    
    // MARK: - Notification Methods
    
    /**
     postCell to send cell to DynamicCellViewController.
     It will add new cell with given key = cellNibName
     
     - parameters:
     - dynamicCellViewController: AppTableBase
     - key : cellNibName defined in DynamicCellKey class
     - sectionTitle : name of the section title, also used to find section index
     - sectionNibName : name of the section nib name for the header view
     - data: static array of data to be used in cell
     - editable: swipe to delete is on if true
     - delay: wait before presenting
     - once: show only once, do not post same cell
     - only: show this cell only, other posted cell will not display
     - tapToDismiss: user option to tap to dismiss
     - return : void
     */
    
    open func postCell(_ parent: AppTableBase? = nil,
                  key: String,
                  afterKey: String? = nil,
                  beforeKey: String? = nil,
                  indexPath: IndexPath? = nil,
                  sectionTitle: String = "section0",
                  blurAlpha: CGFloat = 0,
                  sectionNibName: String? = nil,
                  data: [AnyObject]? = nil,
                  leadingActions: String? = nil,
                  trailingActions: String? = nil,
                  delay: TimeInterval = 0,
                  once: Bool = false,
                  only: Bool = false,
                  cellCache: Bool = false,
                  cellHidden: Bool = false,
                  cellSelectionStyle: String = "none",
                  cellRemoveSeperator: Bool = true,
                  tapToDismiss: Bool = true,
                  userInteractionEnabled: Bool = true,
                  tableViewBottomGap: CGFloat = 0,
                  tableViewBackgroundColor: UIColor = .clear,
                  tableViewScrollToBottom: Bool = false,
                  tableViewClipToBounds: Bool = true,
                  showDismissButton: Bool = false,
                  animation: Bool = true,
                  callback: ((Int?, AnyObject?) -> ())? = nil) {
        
        // set dynamicCellViewController
        self.dynamicCellViewController = parent
        
        // set controller tapToDismiss property
        self.tapToDismiss = tapToDismiss
        
        // set only property to keep on cell
        self.only = only
        
        // check if only one cell presented at a time.
        // if true dismiss all presented cells
        
        if self.only && self.dynamicCellViewController?.tableView.visibleCells.count ?? 0 > 0 {
            self.dismissViewController()
        }
        
        let cell = CellDescriptor(cellName: key,
                                  cellIdentifier: key,
                                  cellNibName: key,
                                  cellSelectionStyle: cellSelectionStyle,
                                  cellData: data,
                                  cellHidden: cellHidden,
                                  cellCache: cellCache,
                                  cellRemoveSeperator: cellRemoveSeperator,
                                  cellLeadingActions: leadingActions,
                                  cellTrailingActions: trailingActions,
                                  cellCallback: callback)

        // check we don't want multiple same cell
        if once {
            if let _ = self.dynamicCellViewController?.findCellIndex(cell) {
                return
            }
        }
        
        // this part is for dynamicly updating
        // data after cell displayed
        
        self.dynamicCellControllerDataUpdatedEvent.bind(self) { [weak self] (data) in
            runOnMainQueue {
                self?.dynamicCellViewController?.insertDataToCell(key, cellData: data ?? [])
                self?.dynamicCellViewController?.reloadData()
            }
        }
        
        // update tablevuew, insert cell, etc.
        runOnMainQueue(after: delay) {
            // show view controller if not already presented
            if self.dynamicCellViewController == nil {
                self.showViewController()
            }
        }
        
        // update tablevuew, insert cell, etc.
        runOnMainQueue(after: delay + 0.1) {
            self.dynamicCellViewController?.view.isUserInteractionEnabled = userInteractionEnabled
            
            // check if it's dynamic actionSheet
            if let dynamicActionSheet = self.dynamicCellViewController as? DynamicActionSheet {
                dynamicActionSheet.blurView.isUserInteractionEnabled = userInteractionEnabled
                dynamicActionSheet.blurView.addBlur(blurAlpha)
                
                runOnMainQueue(after: 0.1) {
                    dynamicActionSheet.updateTableHeight(tableViewBottomGap, animation)
                }
            }

            self.dynamicCellViewController?.tableView?.clipsToBounds = tableViewClipToBounds
            self.dynamicCellViewController?.tableView?.backgroundColor = tableViewBackgroundColor
            self.dynamicCellViewController?.tableView?.addColorToBottom(color: tableViewBackgroundColor)

            if let indexPath = indexPath {
                self.dynamicCellViewController?.addCellAtSection(cell, section: indexPath.section, rowIndex: indexPath.row)
            } else if let (section, row) = self.dynamicCellViewController?.findCellIndex(CellDescriptor(cellName: beforeKey)) {
                self.dynamicCellViewController?.addCellAtSection(cell, section: section, rowIndex: row - 1)
            } else if let (section, row) = self.dynamicCellViewController?.findCellIndex(CellDescriptor(cellName: afterKey)) {
                self.dynamicCellViewController?.addCellAtSection(cell, section: section, rowIndex: row + 1)
            } else {
                self.dynamicCellViewController?.addCellAtSection(cell, sectionNibName: sectionNibName, sectionTitle: sectionTitle)
            }
            
            self.dynamicCellViewController?.tableView?.layoutIfNeeded()

            if tableViewScrollToBottom {
                runOnMainQueue(after: 0.2) {
                    self.dynamicCellViewController?.tableView?.scrollToBottom()
                }
            }
            
            if showDismissButton {
                if let view = DynamicCellController.sharedInstance.dynamicCellViewController?.view {
                    DismissButton.sharedInstance.presentButton(toView: view,
                                                               iconName: "x.circle",
                                                               delay: 0,
                                                               tableViewBottomGap: tableViewBottomGap) {
                        NotificationsCenterManager.sharedInstance.post("DISMISS")
                    }
                }
            }
        }
    }
    
    /**
     dismissCell to dismiss cell from the DynamicCellViewController
     
     - parameters:
     - indexPath : IndexPath of the cell
     - return : void
     */
    
    open func dismissCell(_ indexPath: IndexPath? = nil) {
        self.dismissCell(nil, indexPath)
    }
    
    /**
     dismissCell to dismiss cell from the DynamicCellViewController
     
     - parameters:
     - key : cellNibName defined in DynamicCellKey class
     - indexPath : IndexPath of the cell
     - return : void
     */
    
    open func dismissCell(_ key: String?, _ indexPath: IndexPath? = nil, after: Double = 0.0) {
        
        guard let dynamicCellViewController = self.dynamicCellViewController else {
            Logger.sharedInstance.LogError("*** dynamicCellViewController is nil ***")
            return
        }
        
        // reset to false
        self.only = false

        runOnMainQueue(after: after) {
            
            // check dynamicCellViewController to make sure it's exists
            dynamicCellViewController.removeCell(key, indexPath)
            
            if let dynamicActionSheet = dynamicCellViewController as? DynamicActionSheet {
                dynamicActionSheet.updateTableHeight()
            }
            
            if dynamicCellViewController.tableView.visibleCells.count == 0 {
                self.dismissViewController()
                
                self.dynamicCellViewController = nil
            }
        }
    }
    
    /**
     showViewController
     
     check if we don't have any cells anymore
     then show DynamiCellViewController
     
     - parameters:
     - return : void
     */
    
    open func showViewController() {
        guard let _ = self.dynamicCellViewController?.tableView else {
            NotificationsCenterManager.sharedInstance.post("DYNAMIC_CELL_VIEW")
            return
        }
    }
    
    /**
     dismissViewController
     
     check if we don't have any cells anymore
     then remove DynamiCellViewController
     
     - parameters:
     - return : void
     */
    
    open func dismissViewController() {
        NotificationsCenterManager.sharedInstance.post("DYNAMIC_CELL_VIEW_DISMISS")
        
        Timer.after(0.3) {
            self.dynamicCellViewController?.tableView = nil
            self.dynamicCellViewController = nil
        }
    }
}
