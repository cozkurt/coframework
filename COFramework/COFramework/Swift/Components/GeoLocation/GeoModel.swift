//
//  GeoModel.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit
import MapKit
import CloudKit
import CoreLocation

// GeoModel conforms MKAnnotation protocol
// To make model work with MKMapView delegates

public class GeoModel: NSObject, MKAnnotation {

    // Following properties are reqired for MKAnnotation
    // for callouts

    public var coordinate: CLLocationCoordinate2D
    public var title: String?
    public var subtitle: String?

    // Custom properties used in model to store
    // more information

    public var nibName: String?
    public var data: AnyObject?

    public init(nibName: String?, coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, data: AnyObject?) {
        self.nibName = nibName
        
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        self.data = data
    }
}

public struct ReversedGeoLocation {
    public let name: String            // eg. Apple Inc.
    public let streetName: String      // eg. Infinite Loop
    public let streetNumber: String    // eg. 1
    public let city: String            // eg. Cupertino
    public let state: String           // eg. CA
    public let zipCode: String         // eg. 95014
    public let country: String         // eg. United States
    public let isoCountryCode: String  // eg. US
    
    // Handle optionals as needed
    public init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
    }
}
