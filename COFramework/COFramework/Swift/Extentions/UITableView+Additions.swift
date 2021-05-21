//
//  UITableView+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit
import Foundation

extension UITableView {
	@objc func addColorToBottom(color: UIColor) {
        let tag = 9000009
		
		if self.tableFooterView?.viewWithTag(tag) != nil {
			return
		}
        
        if let _ = self.tableFooterView {} else {
            self.addFooter()
        }
		
		let size = UIScreen.main.bounds
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		
		let bgView = UIView(frame: rect)
		bgView.tag = tag
		bgView.backgroundColor = color
		
		self.tableFooterView?.clipsToBounds = false
		self.tableFooterView?.addSubview(bgView)
	}
    
    @objc func addFooter(height: CGFloat = 0) {
        self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: height))
    }
    
    @objc func addEmptyFooter() {
        self.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    @objc func removeFooter() {
        let tag = 9000009
        if self.tableFooterView?.viewWithTag(tag) != nil {
            self.tableFooterView?.viewWithTag(tag)?.removeFromSuperview()
        }
    }
    
    func scrollToBottom(animated: Bool = true) {
        if self.visibleCells.count == 0 { return }
        
        DispatchQueue.main.async {
            let section = max(self.numberOfSections - 1, 0)
            let row = max(self.numberOfRows(inSection:  section) - 1, 0)
            
            if row == 0 && section == 0 {
                return
            }
            
            let indexPath = IndexPath(row: row, section: section)
            self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    func scrollToTop(animated: Bool = false) {
        if self.visibleCells.count == 0 { return }
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}

extension UITableView {
    
    func setUpRefreshing(_ object: Any, _ refreshText:String = "", handleRefresh: Selector?) {
        if refreshControl == nil {
            addRefreshUI(object, refreshText, handleRefresh)
        }
    }
    
    func endRefreshing() {
        self.refreshControl?.endRefreshing()
    }
    
    func sendValueChangeAction() {
        self.refreshControl?.sendActions(for: .valueChanged)
    }
    
    func addRefreshUI(_ object: Any, _ refreshText:String, _ handleRefresh: Selector?) {
        let refreshControl = UIRefreshControl()
        
        if let handleRefresh = handleRefresh {
            refreshControl.addTarget(object, action: handleRefresh, for: .valueChanged)
        }
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        refreshControl.attributedTitle = NSAttributedString(string: refreshText, attributes: attributes)
        
        self.refreshControl = refreshControl
    }
}
