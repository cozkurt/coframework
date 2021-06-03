//
//  DynamicActionSheet.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/7/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit

open class DynamicActionSheet: AppTableBase {
    
    @IBOutlet public weak var blurView: UIView!
    
    private static var dismissing = false
    
    private var animation: Bool = true
    public var tableViewBottomGap: CGFloat = 0
    
    /// set this flag to true to to use tableview as notification style
    /// it wil adjust tableView y position to snap to bottom with animation
    
    var defaultTableView = false
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addEmptyFooter()
        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tableView?.reloadData()
        self.resetTableHeightPosition()
        
        runOnMainQueue(after: 0.3) {
            self.updateTableHeight(self.tableViewBottomGap, self.animation)
        }
    }
    
    public func resetTableHeightPosition() {
        if defaultTableView {
            return
        }
        
        self.tableView?.frame = CGRect(x: self.tableView.frame.origin.x, y: self.view.frame.height, width: self.tableView.frame.width, height: self.tableView.frame.height)
    }
    
    public func updateTableHeight(_ tableViewBottomGap: CGFloat = 0, _ animation: Bool = true) {
        
        if defaultTableView {
            return
        }
        
        self.animation = animation
        self.tableViewBottomGap = tableViewBottomGap
        self.tableView?.layoutIfNeeded()
  
        UIView.animate(withDuration: animation ? 0.5 : 0, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
            
            let gap:CGFloat = self.tableViewBottomGap
            
            let viewHeight = self.view.frame.height
            let halfScreen = viewHeight / 5
            let tableHeight = self.tableView?.contentSize.height ?? 0
            let adjustedHeight = max(viewHeight - tableHeight, halfScreen + gap)
            
            self.tableView?.frame = CGRect(x: self.tableView.frame.origin.x, y: adjustedHeight - gap, width: self.tableView.frame.width, height: viewHeight - adjustedHeight)
            
        }, completion: nil)
        
        if !animation {
            self.tableView?.alpha = 0
            
            UIView.animate(withDuration: 0.5) {
                self.tableView?.alpha = 1
            }
        }
    }
    
    public func animateDismiss(_ completed: @escaping () -> Void = {}) {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            
            let gap:CGFloat = (UIDevice().isIPhoneX() ? 20 : 10) + self.tableViewBottomGap
            
            self.tableView?.frame.origin.y = self.view.frame.height + gap
        }, completion: {(Bool) -> Void in
            completed()
        })
    }
    
    public func dismiss() {
        if DynamicActionSheet.dismissing { return }
        DynamicActionSheet.dismissing = true
        
        self.animateDismiss {
            DynamicActionSheet.dismissing = false
            NotificationsCenterManager.sharedInstance.post("DISMISS")
        }
    }
    
    @IBAction public func dismissButton() {
        if defaultTableView {
            NotificationsCenterManager.sharedInstance.post("DISMISS")
        } else {
            dismiss()
        }
    }
}
