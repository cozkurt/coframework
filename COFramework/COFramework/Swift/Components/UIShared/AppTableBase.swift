//
//  AppTableBase.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/7/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit

public enum ScrollDirection {
    case idle
    case up
    case down
}

open class AppTableBase: CustomTableBase {
    
    @IBOutlet public var topMenuView: UIView!
    @IBOutlet public var leftButton: UIButton!
    @IBOutlet public var rightButton: UIButton!
    @IBOutlet public var loadingIndicator: UIActivityIndicatorView!
    
    // Grey background below the table
    public var addBottomColor = false
    
    // for subviews
    public var scrollToDismiss = false
    
    // flag for use to control content inset and top menu view
    public var directionUpdates: Bool = false
    
    // (key: nibName, scrollDirection)
    public var lastSrollingDirection: ScrollDirection = .idle
    
    // used by tracking keyboard show/hide
    public var isKeyboardHidden: Bool = true
    public var isKeyboardHidden2: Bool = true
    
    // save previous content inset/constant
    public var previousContentInset: UIEdgeInsets = UIEdgeInsets.zero
    public var previousConstantValue: CGFloat = 0
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove extra spacing in tableview
        tableView?.contentInsetAdjustmentBehavior = .never
        
        // set bottom gap for menu
        self.tableView?.contentInset.bottom = 80
    
        // Grey background below the table
        if addBottomColor {
            self.tableView?.addColorToBottom(color: UIColor.systemBackground)
        }
        
        // update top view position according
        // to scrolling up or down for iPhone only
        
        self.topMenuScrollUpdate()
    }
    
    // configure keyboard only when editing
    // otherwise it's effection tapToDismiss whne using as actionsheet
    
    public func keyboardConfigure(_ cancelsTouchesInView: Bool = false) {
        // add auto dismiss keyboard
        self.hideKeyboardOnTap(cancelsTouchesInView)
        
        // add keyboard scrolling
        self.positionWithKeyboard(tableView)
    }
    
    // this method will change the view's
    // position depends on scrolling up or down
    // with given yDelta o change origin.y
    
    open func topMenuScrollUpdate() {
        
        guard let tableView = self.tableView, let topMenuView = self.topMenuView else {
            return
        }

        let move:CGFloat = -50

        topMenuView.frame.origin.y = 0
        tableView.contentInset.top = topMenuView.frame.size.height
        
        runOnMainQueue(after: 0.1) {
            tableView.scrollToTop(animated: false)
        }
        
        if self.directionUpdates && UIDevice().isIPhone() {
            
            CustomTableBase.tableViewScrollingUpEvent.bind(self) { nibName in
                if self.nibName != nibName { return }
                
                UIView.animate(withDuration: 0.3) {
                    self.leftButton?.alpha = 0
                    self.rightButton?.alpha = 0
                    
                    topMenuView.frame.origin.y = move
                }
            }
            
            CustomTableBase.tableViewScrollingDownEvent.bind(self) { nibName in
                if self.nibName != nibName { return }
                
                UIView.animate(withDuration: 0.3) {
                    self.leftButton?.alpha = 1
                    self.rightButton?.alpha = 1
                    
                    topMenuView.frame.origin.y = 0
                }
            }
            
            self.lastSrollingDirection = .idle
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationsCenterManager.sharedInstance.removeObserver(self)
    }
    
    // refresh controller handler
    func handleRefresh(_ sender: Any) {
        // override
    }
    
    open func showLoadingIndicator() {
        runOnMainQueue {
            self.rightButton?.isHidden = true
            self.loadingIndicator?.startAnimating()
        }
    }
    
    open func hideLoadingIndicator() {
        runOnMainQueue {
            self.rightButton?.isHidden = false
            self.loadingIndicator?.stopAnimating()
            
            self.tableView?.endRefreshing()
        }
    }
}

extension AppTableBase {
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        guard let nibName = self.nibName, self.directionUpdates == true else {
            return
        }
        
        // this value for the difference between current y adn target y
        let targetDiff: CGFloat = 150.0
        let distanceToTop: CGFloat = 20.0

        // notify scrolling up/down
        if targetContentOffset.pointee.y + targetDiff < scrollView.contentOffset.y || targetContentOffset.pointee.y < distanceToTop {
            if self.lastSrollingDirection != .up {
                
                CustomTableBase.tableViewScrollingDownEvent.notify(nibName)
                self.lastSrollingDirection = .up
            }
        } else if targetContentOffset.pointee.y - targetDiff > scrollView.contentOffset.y {
            if self.lastSrollingDirection != .down {
                
                CustomTableBase.tableViewScrollingUpEvent.notify(nibName)
                self.lastSrollingDirection = .down
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let percentage = scrollView.frame.height * 0.2

        if self.scrollToDismiss && scrollView.contentOffset.y < -percentage {
            NotificationsCenterManager.sharedInstance.post("DISMISS")
        }
    }
}

extension AppTableBase {

    public func hideKeyboardOnTap(_ cancelsTouchesInView: Bool = false) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard))
        tap.cancelsTouchesInView = cancelsTouchesInView
        view.addGestureRecognizer(tap)
    }

    @objc public func closeKeyboard() {
        view.endEditing(true)
    }
    
    public func positionWithKeyboard(_ scrollView: UIScrollView) {
        NotificationsCenterManager.sharedInstance.addObserver(self, forName: UIResponder.keyboardWillShowNotification.rawValue) { (notification) in
            
            if !self.isKeyboardHidden { return }
            self.isKeyboardHidden = false
            
            self.previousContentInset = scrollView.contentInset
            
            let keyboardHeight = self.keyboardHeight(notification: notification)
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: keyboardHeight, right: scrollView.contentInset.right)

            runOnMainQueue {
                UIView.animate(withDuration: 0.3) {
                    scrollView.contentInset = contentInsets
                    scrollView.scrollIndicatorInsets = contentInsets
                    scrollView.layoutIfNeeded()
                }
            }
        }
        
        NotificationsCenterManager.sharedInstance.addObserver(self, forName: UIResponder.keyboardWillHideNotification.rawValue) { (notification) in

            if self.isKeyboardHidden { return }
            self.isKeyboardHidden = true

            runOnMainQueue {
                UIView.animate(withDuration: 0.3) {
                    scrollView.contentInset = self.previousContentInset
                    scrollView.scrollIndicatorInsets = self.previousContentInset
                    scrollView.layoutIfNeeded()
                }
            }
        }
    }
    
    public func positionWithKeyboard(_ constraint: NSLayoutConstraint) {
        NotificationsCenterManager.sharedInstance.addObserver(self, forName: UIResponder.keyboardWillShowNotification.rawValue) { (notification) in
            
            if !self.isKeyboardHidden2 { return }
            self.isKeyboardHidden2 = false
            
            self.previousConstantValue = constraint.constant
            
            let keyboardHeight = self.keyboardHeight(notification: notification)

            runOnMainQueue {
                UIView.animate(withDuration: 0.3) {
                     constraint.constant += keyboardHeight - self.bottomSpaceOfViewController()
                     self.view.layoutIfNeeded()
                }
            }
        }
        
        NotificationsCenterManager.sharedInstance.addObserver(self, forName: UIResponder.keyboardWillHideNotification.rawValue) { (notification) in
            
            if self.isKeyboardHidden2 { return }
            self.isKeyboardHidden2 = true
            
            runOnMainQueue {
                UIView.animate(withDuration: 0.3) {
                    constraint.constant = self.previousConstantValue
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    public func keyboardHeight(notification: Foundation.Notification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        let keyboardHeight = keyboardSize.height + (UIDevice().isIPad() ? 30.0 : 0.0)
        
        return keyboardHeight
    }
    
    // helper method to find space to window bottom
    public func bottomSpaceOfViewController() -> CGFloat {
        let viewHeight = self.view.bounds.size.height
        let windowHeight = UIDevice().bounds.height
        
        return windowHeight - viewHeight - 20
    }
}
