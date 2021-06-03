//
//  ResizableImageView.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 3/30/20.
//  Copyright © 2020 FuzFuz. All rights reserved.
//

import UIKit
import Foundation

public class ResizableImageView: UIImageView, UIGestureRecognizerDelegate {
    
    /// bindable objects to listen
    public static var imageTapped: Signal = Signal()
    
    var autoReset = false
    var originalImageCenter: CGPoint?
    var newScale: CGFloat = 0
    var simultaneousGesturesAllowed = true
    
    public override init(image: UIImage?) {
        super.init(image: image)
        
        self.addGestures()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addGestures()
    }
    
    public func addGestures() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        pinch.delegate = self
        self.addGestureRecognizer(pinch)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(sender:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(self.tap(sender:)))
        tap.numberOfTapsRequired = 2
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.isUserInteractionEnabled = true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return simultaneousGesturesAllowed
    }
    
    @objc func tap(sender:UITapGestureRecognizer) {
        ResizableImageView.imageTapped.notify()
    }
    
    @objc  func pan(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            if self.originalImageCenter == nil {
                self.originalImageCenter = sender.view?.center
            }
            
            self.simultaneousGesturesAllowed = false
            
        } else if sender.state == .changed {
            let translation = sender.translation(in: self)
            if let view = sender.view {
                view.center = CGPoint(x:view.center.x + translation.x * self.newScale,
                                      y:view.center.y + translation.y * self.newScale)
            }
            sender.setTranslation(CGPoint.zero, in: self.superview)
        } else if sender.state == .ended {
            self.simultaneousGesturesAllowed = true
        }
    }
    
    @objc func pinch(sender:UIPinchGestureRecognizer) {
        
        if sender.state == .began {
            let currentScale = self.frame.size.width / self.bounds.size.width
            self.newScale = currentScale * sender.scale
            
            self.simultaneousGesturesAllowed = false
            
        } else if sender.state == .changed {
            
            guard let view = sender.view else {return}
            
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                      y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            
            let currentScale = self.frame.size.width / self.bounds.size.width
            self.newScale = currentScale*sender.scale
            
            if newScale < 1 {
                newScale = 1
            } else {
                view.transform = transform
                sender.scale = 1
            }

        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            
            if self.autoReset == false {
                return
            }
            
            self.simultaneousGesturesAllowed = true
            self.resetImagePosition()
        }
    }
    
    @IBAction public func resetImagePosition() {
        guard let center = self.originalImageCenter else {return}
        
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform.identity
            self.center = center
        })
    }
}
