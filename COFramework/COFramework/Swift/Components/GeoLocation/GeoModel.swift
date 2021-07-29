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

open class GeoModel: NSObject, MKAnnotation {

    // Following properties are reqired for MKAnnotation
    // for callouts

    open var coordinate: CLLocationCoordinate2D
    open var title: String?
    open var subtitle: String?

    // Custom properties used in model to store
    // more information

    var nibName: String?
    var data: AnyObject?

    init(nibName: String?, coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, data: AnyObject?) {
        self.nibName = nibName
        
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        self.data = data
    }
}

struct ReversedGeoLocation {
    let name: String            // eg. Apple Inc.
    let streetName: String      // eg. Infinite Loop
    let streetNumber: String    // eg. 1
    let city: String            // eg. Cupertino
    let state: String           // eg. CA
    let zipCode: String         // eg. 95014
    let country: String         // eg. United States
    let isoCountryCode: String  // eg. US
    
    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
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
