//
//  UIView+Border.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

extension UIView {

    @objc func addBorderTop(_ size: CGFloat, color: UIColor) {
        addBorder(0, y: 0, width: frame.width, height: size, color: color)
    }

    @objc func addBorderBottom(_ size: CGFloat, color: UIColor) {
        addBorder(0, y: frame.height - size, width: frame.width, height: size, color: color)
    }

    @objc func addBorderLeft(_ size: CGFloat, color: UIColor) {
        addBorder(0, y: 0, width: size, height: frame.height, color: color)
    }

    @objc func addBorderRight(_ size: CGFloat, color: UIColor) {
        addBorder(frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }

    fileprivate func addBorder(_ x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    
    @objc func addDashedLine(_ y: CGFloat, color: UIColor = UIColor.black) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: frame.width / 2, y: y)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [2, 2]  // lenght, gap
        
        let path: CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))        
        shapeLayer.path = path
        
        layer.addSublayer(shapeLayer)
    }
}
