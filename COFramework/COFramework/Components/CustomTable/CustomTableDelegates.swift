//
//  TableDelegates.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit
import Foundation

/*
 *  MARK: - UITableViewDelegate, UITableViewDataSource
 */
extension CustomTableBase: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowsInSection(section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let (cell, _, _) = self.tableCell(forIndexPath: indexPath)
        
        if indexPath.row + 1 == self.numberOfRowsInSection(indexPath.section) {
            CustomTableBase.tableViewCellEndEvent.notify(cell.reuseIdentifier)
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRowAtIndexPath(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRowAtIndexPath(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerViewForSection(section)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeaderInSection(section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.footerViewForSection(section)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.heightForFooterInSection(section)
    }
    
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let (cellDescriptor, _) = self.cellModelWithUpdatedIndex(forIndexPath: indexPath), let cellNibName = cellDescriptor.cellNibName, let cellLeadingActions = cellDescriptor.cellLeadingActions else {
            return nil
        }
        
        return self.actionConfiguration(cellNibName: cellNibName, cellActions: cellLeadingActions, indexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let (cellDescriptor, _) = self.cellModelWithUpdatedIndex(forIndexPath: indexPath), let cellNibName = cellDescriptor.cellNibName, let cellTrailingActions = cellDescriptor.cellTrailingActions else {
            return nil
        }
        
        return self.actionConfiguration(cellNibName: cellNibName, cellActions: cellTrailingActions, indexPath: indexPath)
    }
    
    func actionConfiguration(cellNibName: String, cellActions: String?, indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cellActions = cellActions else {
            return nil
        }
        
        var config: [UIContextualAction] = []
        
        for item in cellActions.components(separatedBy: ",") {
            let title = item.components(separatedBy: "|").first ?? item
            
            let contextualAction = UIContextualAction(style: .destructive, title: title.localize()) { (action, sourceView, completionHandler) in

                CustomTableBase.tableViewCellEditingEvent.notify((title, cellNibName, indexPath))
                completionHandler(true)
            }
            
            contextualAction.backgroundColor = item.components(separatedBy: "|").last?.color
            config.append(contextualAction)
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: config)
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        
        return swipeActionConfig
    }
}

/*
 *  MARK: - Handles Section Header Taps
 */
extension CustomTableBase {
    
    @objc func handleSectionTap(_ gesture: UITapGestureRecognizer) {
        
        guard let section = gesture.view?.tag, let _ = self.sectionDescriptors[section].sectionNibName,
            let sectionExpandable = self.sectionDescriptors[section].sectionExpandable,
            let sectionExpanded = self.sectionDescriptors[section].sectionExpanded else { return }
        
        if sectionExpandable {
            self.sectionDescriptors[section].sectionExpanded = !sectionExpanded
            
            if let tableView = self.tableView {
                tableView.reloadSections(IndexSet(integer: section), with: UITableView.RowAnimation.none)
                
                if self.sectionDescriptors[section].sectionExpanded == true {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .none, animated: true)
                }
                
                if let hView = gesture.view as? CustomHeaderTapProtocol {
                    hView.headerTapped(self.sectionDescriptors[section], section: section)
                }
            }
        }
    }
}
