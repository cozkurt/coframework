//
//  CircleAnimatedView.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 01/06/20.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

@IBDesignable
class CircleAnimatedView: UIView {
    
    @IBInspectable var circleColor: UIColor = UIColor(red: 205/255, green: 209/255, blue: 216/255, alpha: 1)
    
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var toLineWidth: CGFloat = 1
    @IBInspectable var timeOffset: CGFloat = 0
    @IBInspectable var startScale: CGFloat = 0.3
    @IBInspectable var endScale: CGFloat = 1
    @IBInspectable var duration: CFTimeInterval = 4
    
    override func draw(_ rect: CGRect) {
        
        self.clearSubLayers()
        self.dynamicCircle(rect)
    }
    
    @objc func dynamicCircle(_ rect: CGRect) {
        
        let path = UIBezierPath()
        
        let from = self.degreeToRadians(0)
        let to = self.degreeToRadians(360)
        
        path.addArc(withCenter: CGPoint(x: rect.size.width/2, y: rect.size.height/2), radius: rect.size.width/2, startAngle: CGFloat(from), endAngle: CGFloat(to), clockwise: true)
        
        let circleLayer = CAShapeLayer()
        
        circleLayer.path = path.cgPath
        circleLayer.frame = self.bounds
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = circleColor.cgColor
        circleLayer.lineWidth = lineWidth
        
        // scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.timeOffset = CACurrentMediaTime() + CFTimeInterval(timeOffset)
        scaleAnimation.fromValue = startScale
        scaleAnimation.toValue = endScale
        scaleAnimation.duration = duration
        scaleAnimation.repeatCount = Float.infinity
        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: "easeOut"))
        
        circleLayer.add(scaleAnimation, forKey: layer.name)
        
        // opacity animation
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.timeOffset = CACurrentMediaTime() + CFTimeInterval(timeOffset)
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.duration = duration
        opacityAnimation.repeatCount = Float.infinity
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: "easeIn"))
        
        circleLayer.add(opacityAnimation, forKey: layer.name)
        
        // lineWidth animation
        
        let lineAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineAnimation.timeOffset = CACurrentMediaTime() + CFTimeInterval(timeOffset)
        lineAnimation.fromValue = lineWidth
        lineAnimation.toValue = toLineWidth
        lineAnimation.duration = duration
        lineAnimation.isRemovedOnCompletion = false
        lineAnimation.repeatCount = Float.infinity
        
        circleLayer.add(lineAnimation, forKey: layer.name)
        
        self.layer.addSublayer(circleLayer)
    }
    
    override internal func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    @objc func clearSubLayers() {
        guard let subLayers = self.layer.sublayers else { return }
        
        for layer in subLayers {
            if layer.isKind(of: CAShapeLayer.self) {
                layer.removeAllAnimations()
                layer.removeFromSuperlayer()
            }
        }
    }
    
    @objc func radiansToDegree(_ radians: Double) -> Double {
        return (radians) * (180.0 / Double.pi)
    }
    
    @objc func degreeToRadians(_ degree: Double) -> Double {
        return ((degree) / 180.0 * Double.pi)
    }
}

