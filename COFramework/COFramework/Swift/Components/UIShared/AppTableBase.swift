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

public class AppTableBase: CustomTableBase {
    
    @IBOutlet var topMenuView: UIView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var addBottomColor = true
    var scrollToDismiss = true
    
    // flag for use to control content inset and top menu view
    var directionUpdates: Bool = false
    
    // (key: nibName, scrollDirection)
    var lastSrollingDirection: ScrollDirection = .idle
    
    // used by tracking keyboard show/hide
    var isKeyboardHidden: Bool = true
    var isKeyboardHidden2: Bool = true
    
    // save previous content inset/constant
    var previousContentInset: UIEdgeInsets = UIEdgeInsets.zero
    var previousConstantValue: CGFloat = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove extra spacing in tableview
        tableView?.contentInsetAdjustmentBehavior = .never
        
        // set bottom gap for menu
        self.tableView?.contentInset.bottom = 80
    
        // Grey background below the table
        if addBottomColor {
            self.tableView?.addColorToBottom(color: UIColor.systemBackground)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // update top view position according
        // to scrolling up or down for iPhone only
        
        self.topMenuScrollUpdate()
    }
    
    // configure keyboard only when editing
    // otherwise it's effection tapToDismiss whne using as actionsheet
    
    func keyboardConfigure(_ cancelsTouchesInView: Bool = false) {
        // add auto dismiss keyboard
        self.hideKeyboardOnTap(cancelsTouchesInView)
        
        // add keyboard scrolling
        self.positionWithKeyboard(tableView)
    }
    
    // this method will change the view's
    // position depends on scrolling up or down
    // with given yDelta o change origin.y
    
    func topMenuScrollUpdate() {
        
        guard let height = self.topMenuView?.frame.size.height else {
            return
        }

        let move:CGFloat = -50

        self.topMenuView?.frame.origin.y = 0
        self.tableView?.contentInset.top = height
        
        self.tableView?.scrollToTop()
        
        if self.directionUpdates && UIDevice().isIPhone() {
            CustomTableBase.tableViewScrollingUpEvent.bind(self) { nibName in
                if self.nibName != nibName { return }
                
                UIView.animate(withDuration: 0.3) {
                    self.leftButton?.alpha = 0
                    self.rightButton?.alpha = 0
                    
                    self.topMenuView?.frame.origin.y = move
                }
            }
            
            CustomTableBase.tableViewScrollingDownEvent.bind(self) { nibName in
                if self.nibName != nibName { return }
                
                UIView.animate(withDuration: 0.3) {
                    self.leftButton?.alpha = 1
                    self.rightButton?.alpha = 1
                    
                    self.topMenuView?.frame.origin.y = 0
                }
            }
            
            self.lastSrollingDirection = .idle
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationsCenterManager.sharedInstance.removeObserver(self)
    }
    
    // refresh controller handler
    @objc func handleRefresh(_ sender: Any) {
        // override
    }
    
    func showLoadingIndicator() {
        runOnMainQueue {
            self.rightButton?.isHidden = true
            self.loadingIndicator?.startAnimating()
        }
    }
    
    func hideLoadingIndicator() {
        runOnMainQueue {
            self.rightButton?.isHidden = false
            self.loadingIndicator?.stopAnimating()
            
            self.tableView?.endRefreshing()
        }
    }
}

extension AppTableBase {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let percentage = scrollView.frame.height * 0.2

        if self.scrollToDismiss && scrollView.contentOffset.y < -percentage {
            NotificationsCenterManager.sharedInstance.post("DISMISS")
        }
    }
}

extension AppTableBase {

    func hideKeyboardOnTap(_ cancelsTouchesInView: Bool = false) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard))
        tap.cancelsTouchesInView = cancelsTouchesInView
        view.addGestureRecognizer(tap)
    }

    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    func positionWithKeyboard(_ scrollView: UIScrollView) {
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
    
    func positionWithKeyboard(_ constraint: NSLayoutConstraint) {
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
    
    func keyboardHeight(notification: Foundation.Notification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        let keyboardHeight = keyboardSize.height + (UIDevice().isIPad() ? 30.0 : 0.0)
        
        return keyboardHeight
    }
    
    // helper method to find space to window bottom
    func bottomSpaceOfViewController() -> CGFloat {
        let viewHeight = self.view.bounds.size.height
        let windowHeight = UIDevice().bounds.height
        
        return windowHeight - viewHeight - 20
    }
}
