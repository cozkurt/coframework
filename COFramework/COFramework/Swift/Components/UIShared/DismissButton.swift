//
//  DismissButton.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/7/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit

public class DismissButton {
    
    let tag = 12345
    public typealias ButtonClickedEvent = () -> Void
    
    var tableViewBottomGap: CGFloat = 0
    var buttonClickedEvent:ButtonClickedEvent?
    var dismissIconView:UIImageView?
    var toView: UIView?
    
    /// Singleton instance
    public static let sharedInstance = DismissButton()
    
    public func presentButton(toView: UIView,
                       iconName: String,
                       delay: TimeInterval,
                       tableViewBottomGap: CGFloat = 0,
                       buttonClickedEvent: @escaping ButtonClickedEvent) {
        
        self.tableViewBottomGap = tableViewBottomGap
        self.buttonClickedEvent = buttonClickedEvent
        self.toView = toView

        Timer.after(delay) {
            
            self.dismissIconView = UIImageView(image: UIImage(systemName: iconName) ?? UIImage(named: iconName))
			self.dismissIconView?.accessibilityIdentifier = "CLOSE_BUTTON"
            
            if let dismissIconView = self.dismissIconView {
                
                // if icon already on the viww, just update gesture
                if let _ = self.toView?.viewWithTag(self.tag) {
                    self.addGesture(toView: dismissIconView)
                    return
                }
                
                dismissIconView.tag = self.tag
                dismissIconView.frame.origin.y = toView.frame.height + dismissIconView.frame.size.height
                dismissIconView.frame.origin.x = toView.frame.width / 2 - dismissIconView.frame.size.width / 2
                dismissIconView.autoresizingMask = [.flexibleBottomMargin]
                
                self.addGesture(toView: dismissIconView)
                toView.addSubview(dismissIconView)
                
                self.showButton()
            }
        }
    }
    
    public func showButton() {
        guard let toView = self.toView, let dismissIconView = self.dismissIconView else {
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.dismissIconView?.frame.origin.y = toView.frame.height - dismissIconView.frame.size.height - (self.tableViewBottomGap - 25)
        }, completion: nil)
    }
    
    public func dismissButton(_ completion: ((Bool) -> Void)? = nil) {
        guard let toView = self.toView else {
            if let completion = completion {
                completion(false)
            }
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.dismissIconView?.frame.origin.y = toView.frame.height + self.tableViewBottomGap + 80
        }, completion: completion)
    }
    
    private func addGesture(toView: UIImageView) {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.buttonClicked))
        recognizer.numberOfTapsRequired = 1
        
        toView.addGestureRecognizer(recognizer)
        toView.isUserInteractionEnabled = true
    }
    
    @objc private func buttonClicked() {
        if let buttonClickedEvent = self.buttonClickedEvent {
            dismissButton() { _ in
                buttonClickedEvent()
            }
        }
    }
}
