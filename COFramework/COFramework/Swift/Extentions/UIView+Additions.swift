//
//  UIView+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

extension UIView {
    
    public func removeAllSubviews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    public func showAnimateAlpha(alpha: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.alpha = alpha
        }) { _ in
        }
    }
    
    public func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superview(of: type) }
    }
    
    public func subview<T>(of type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T ?? $0.subview(of: type) }.first
    }
    
    public class func fromNib(_ nibName: String, index: Int?) -> UIView? {
        if let views = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil) {
            
            let view: UIView?
            
            if let index = index {
                view = views[index] as? UIView
            } else {
                view = views[0] as? UIView
            }
            
            if let view = view {
                return view
            } else {
                return nil
            }
        }
        return nil
    }
    
    public class func accessoryViewWithButton(_ nibName: String, label:String, target: AnyObject?, action: Selector) -> UIView? {
        if let view = UIView.fromNib(nibName, index: 0) {
            
            if let button: UIButton = view.viewWithTag(100) as? UIButton {
                button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
                button.setTitle(label.localize(), for: .normal)
            }
            
            return view
        }
         return nil
    }
    
    public class func accessoryViewWithTextView(_ nibName: String, text:String, delegate: UITextViewDelegate) -> UIView? {
        if let view = UIView.fromNib(nibName, index: 0) {
            
            if let textView: CustomTextView = view.viewWithTag(100) as? CustomTextView {
                textView.delegate = delegate
                textView.text = text
            }
            
            return view
        }
         return nil
    }
    
    public func setAnchorPoint(_ anchorPoint: CGPoint) {
        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)
        
        var position : CGPoint = self.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        self.layer.position = position
        self.layer.anchorPoint = anchorPoint
    }
    
    public func applyDefaultGradient() {
        self.applyGradient([UIColor.systemBlue, UIColor.systemBackground ], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0.8, y: 1.0), cornerRadius: 5, opacity: 0.1, animated: false)
    }
    
    public func applyDefaultGradient2() {
        self.applyGradient([UIColor.systemBlue, UIColor.systemBackground ], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0.8, y: 1.0), cornerRadius: 5, opacity: 0.2, animated: false)
    }
    
    public func applyGradient(_ colours: [UIColor], startPoint: CGPoint, endPoint: CGPoint, cornerRadius: CGFloat, opacity: Float, animated: Bool = false) -> Void {
        
        self.removeGradients()
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.locations = [0, 1]
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.cornerRadius = cornerRadius
        gradient.opacity = opacity

        if animated {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 0
            animation.toValue = opacity
            animation.duration = 0.3
            
            gradient.add(animation, forKey: nil)
        }
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    public func removeGradients() -> Void {
        
        if let layers = self.layer.sublayers {
            for layer in layers {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    public func removeSublayers() -> Void {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    public func removeAll() {
//        self.layer.sublayers?.forEach { $0.removeAllAnimations() }
//        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
//
//        self.layer.removeAllAnimations()
        
        self.removeFromSuperview()
    }
    
    public func animateTo(frame: CGRect, withDuration duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        guard let _ = superview else {
            return
        }
        
        let xScale = frame.size.width / self.frame.size.width
        let yScale = frame.size.height / self.frame.size.height
        let x = frame.origin.x + (self.frame.width * xScale) * self.layer.anchorPoint.x
        let y = frame.origin.y + (self.frame.height * yScale) * self.layer.anchorPoint.y
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.layer.position = CGPoint(x: x, y: y)
            self.transform = self.transform.scaledBy(x: xScale, y: yScale)
            self.layoutIfNeeded()
        }, completion: completion)
    }
    
    public func scaleTo(scale: CGFloat, withDuration duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        guard let _ = superview else {
            return
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = self.transform.scaledBy(x: scale, y: scale)
            self.layoutIfNeeded()
        }, completion: completion)
    }
    
    public func resizeToFitSubviews() {
        var w: CGFloat = 0
        var h: CGFloat = 0
        
        for v in self.subviews {
            let fw = v.frame.origin.x + v.frame.size.width
            let fh = v.frame.origin.y + v.frame.size.height
            w = max(fw, w)
            h = max(fh, h)
        }
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: w, height: h)
    }
}

// Blur
public protocol Bluring {
    func addBlur(_ alpha: CGFloat)
}

extension Bluring where Self: UIView {
    public func addBlur(_ alpha: CGFloat = 0.5) {
        
        let isBlurExists = self.subviews.count > 0
        
        if alpha > 0 && !isBlurExists {
            // create effect
            let effect = UIBlurEffect(style: .dark)
            let effectView = UIVisualEffectView(effect: effect)
            
            // set boundry and alpha
            effectView.frame = self.bounds
            effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            effectView.alpha = 0
            
             self.addSubview(effectView)
            
            UIView.animate(withDuration: 0.3) {
               effectView.alpha = alpha
            }
            
        }
    }
    
    public func removeBlur() {
        self.removeAllSubviews()
    }
}

// Conformance
extension UIView: Bluring {}

// Gesture recognizer
extension UIView {
    public func userStartedGesture() -> Bool {
        
        guard let view = self.subviews.first, let gestureReconizers = view.gestureRecognizers else {
            return false
        }
        
        for recognizer in gestureReconizers {
            if recognizer.state ==  UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended {
                return true
            }
        }
        
        return false
    }
}
