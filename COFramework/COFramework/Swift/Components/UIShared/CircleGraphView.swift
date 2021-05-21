//
//  CircleGraphView.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 01/06/20.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

@IBDesignable
class CircleGraphView: UIView {
    
    @IBOutlet var label: UILabel!
    
    @IBInspectable var outerCircleColor: UIColor?
    @IBInspectable var innerCircleColor: UIColor?
    
    @IBInspectable var fontSize:CGFloat = 14
    @IBInspectable var fontSuperSize:CGFloat = 10
    @IBInspectable var bolderFont:Bool = false
    
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var startDegree: Double = 0
    @IBInspectable var fromDegree: Double = 0
    @IBInspectable var toDegree: Double = 12.0 {
        didSet {
			let text = "\(Int(((self.toDegree - self.fromDegree).rounded(.toNearestOrAwayFromZero) * 100 / 360).rounded(.toNearestOrAwayFromZero)))%"
            
            let font: UIFont = UIFont.defaultFontWithSize(fontDefault: defaultFontName, ofSize: fontSize, andWeight: bolderFont ? UIFont.Weight.medium : UIFont.Weight.regular)!
			let fontSuper: UIFont = UIFont.defaultFontWithSize(fontDefault: defaultFontName, ofSize: fontSuperSize, andWeight: UIFont.Weight.regular)!
			let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [.font: font])
            
            var attributes = [
                NSAttributedString.Key.font: fontSuper,
                NSAttributedString.Key.baselineOffset: fontSize / 5
            ] as [NSAttributedString.Key : Any]
            let percentColor = AppearanceController.sharedInstance.color("percentColor", defaultColor: .clear)
            if percentColor != .clear {
                attributes[NSAttributedString.Key.foregroundColor] = percentColor
            }
            
			attString.setAttributes(attributes, range: NSRange(location: text.count - 1, length: 1))
			self.label?.attributedText = attString
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        self.clearSubLayers()
        
        self.fixedCircle(rect)
        self.dynamicCircle(rect)
    }
    
    @objc func dynamicCircle(_ rect: CGRect) {
        let path = UIBezierPath()
        
        let radius = rect.size.width/2 - (self.lineWidth + 1.5)
        
        let from = self.degreeToRadians(self.fromDegree + self.startDegree)
        let to = self.degreeToRadians(self.toDegree + self.startDegree)
        
        path.addArc(withCenter: CGPoint(x: rect.size.width/2,y: rect.size.height/2), radius: radius, startAngle: CGFloat(from), endAngle: CGFloat(to), clockwise: true)
        
        let circleLayer = CAShapeLayer()
        
        circleLayer.path = path.cgPath
        circleLayer.frame = self.bounds
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = innerCircleColor?.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.lineCap = CAShapeLayerLineCap.round
        
        self.layer.addSublayer(circleLayer)
    }
    
    @objc func fixedCircle(_ rect: CGRect) {
        let path = UIBezierPath()
        
        let radius = rect.size.width/2 - 1

        let from = self.degreeToRadians(0)
        let to = self.degreeToRadians(360)
        
        path.addArc(withCenter: CGPoint(x: rect.size.width/2,y: rect.size.height/2), radius: radius, startAngle: CGFloat(from), endAngle: CGFloat(to), clockwise: true)
        
        let dynamicCircle = CAShapeLayer()
        
        dynamicCircle.path = path.cgPath
        dynamicCircle.frame = self.bounds
        dynamicCircle.fillColor = UIColor.clear.cgColor
        dynamicCircle.strokeColor = outerCircleColor?.cgColor
        dynamicCircle.lineWidth = lineWidth / 2
        
        self.layer.addSublayer(dynamicCircle)
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

