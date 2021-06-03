//
//  CLLocation+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 4/9/20.
//  Copyright © 2020 FuzFuz. All rights reserved.
//

import MapKit
import CoreLocation
import Foundation

extension CLLocation {
    
    // usage : text = location?.distanceString(toLocation: AppPersistence.lastLocation)
    
    public func distanceToCurrentLocation(currentLocation: CLLocation?) -> String {
        guard let currentLocation = currentLocation else {
            return ""
        }
        
        return self.distanceString(toLocation: currentLocation)
    }
    
    public func distanceString(toLocation: CLLocation?) -> String {
        guard let meters = toLocation?.distance(from: self) else {
            return ""
        }
        
        return self.distanceString(meters: meters)
    }
    
    public func distanceString(meters: CLLocationDistance) -> String {
        
        let formatter = MeasurementFormatter()
        
        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.unitOptions = .naturalScale
        formatter.unitStyle = .short

        let unit = Measurement(value: meters, unit: UnitLength.meters)
        let convertedUnit = Locale.current.regionCode == "US" ? unit.converted(to: UnitLength.miles) : unit.converted(to: UnitLength.kilometers)
        
        return formatter.string(from: convertedUnit)
    }
    
    // This method is used for converstion from miles to kilometers or vise versa
    
    public func metersConverted(miles: CLLocationDistance) -> CLLocationDistance {
        let meters = Locale.current.regionCode == "US" ? Measurement(value: miles, unit: UnitLength.miles) : Measurement(value: miles, unit: UnitLength.kilometers)
        
        return meters.converted(to: UnitLength.meters).value
    }
}
