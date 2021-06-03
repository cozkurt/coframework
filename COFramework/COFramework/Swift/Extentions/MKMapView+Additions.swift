//
//  MKMapView+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 12/13/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import MapKit
import CoreLocation
import Foundation

extension MKMapView {

    public var topCenterCoordinate: CLLocationCoordinate2D {
        return self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
    }

    public var currentRadius: Double {
        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
        let topCenterLocation = CLLocation(latitude: self.topCenterCoordinate.latitude, longitude: self.topCenterCoordinate.longitude)
        
        return centerLocation.distance(from: topCenterLocation)
    }
}
