//
//  GeoCircleOverlay.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 3/3/20.
//  Copyright © 2020 FuzFuz. All rights reserved.
//

import UIKit
import MapKit

public class GeoCircleOverlay: MKCircle {

    public var lineWidth: CGFloat?
    public var strokeColor: UIColor?
    public var fillColor: UIColor?
    
    public convenience init(center: CLLocationCoordinate2D, radius: CLLocationDistance, lineWidth:CGFloat?, strokeColor: UIColor?, fillColor: UIColor?) {
        self.init(center: center, radius: radius)
        
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor
        self.fillColor = fillColor
    }
}
