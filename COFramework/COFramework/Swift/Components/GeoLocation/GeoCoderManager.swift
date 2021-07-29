//
//  GeoCoderManager.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 1/23/20.
//  Copyright © 2020 FuzFuz. All rights reserved.
//

import MapKit
import Foundation

public class GeoCoderManager: NSObject, MKLocalSearchCompleterDelegate {
    
    public var geocodeCache:[String:CLLocation] = [:]
    public var reverseGeocodeCache:[String:ReversedGeoLocation] = [:]
    
    public lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let sc = MKLocalSearchCompleter()
        sc.delegate = self
        return sc
    }()
    
    public var localSearchCompleterBlock: (([String]?) -> ())?
    
    //
    // MARK: - sharedInstance for singleton access
    //
    public static let sharedInstance: GeoCoderManager = GeoCoderManager()
    
    /**
     Search given address and atuo completes results

     - parameter address:    The Address string.
     - parameter completion:  completion block returning objects with the city, state, and country data
     - returns void
     */

    public func searchGeocodeAddressesAutoComplete(_ address: String?, completion: (([String]?) -> ())?) {
        if let address = address {
            self.localSearchCompleterBlock = completion
            self.localSearchCompleter.queryFragment = address
        }
    }
    
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.localSearchCompleterBlock?(completer.results.map { $0.title })
    }

    public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    /**
     geocodeLocation get city, state, country data to latitude and longitude
     
     - parameter address:  address to get CLLocation
     - parameter completion:  completion block returning CLLocation
     
     - returns void
     */
    
    public func geocodeLocation(address: String, completion:@escaping (CLLocation?) -> Void) {
        
        if let cachedAddress = geocodeCache[address] {
            completion(cachedAddress)
            return
        }
        
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if let location = placemarks?.first?.location {
                self.geocodeCache[address] = location
                completion(location)
            } else {
                completion(nil)
            }
        }
    }
    
    /**
     reverseGeocodeLocation get city, state, country data from latitude and longitude
     
     - parameter latitude:  latitude of location coordinate
     - parameter longitude:  longitude of location coordinate
     - parameter completion:  completion block returning the ReversedGeoLocation object with the city, state, and country data
     
     - returns void
     */
    
    public func reverseGeocodeLocation(latitude:Double, longitude:Double, completion:@escaping (ReversedGeoLocation?) -> Void) {
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let locationHash:String = String(latitude) + String(longitude)
        
        if let cachedLocation = reverseGeocodeCache[locationHash] {
            completion(cachedLocation)
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            
            guard let placemark = placemarks?.first else {
                let errorString = error?.localizedDescription ?? "Unexpected Error"
                print("Unable to reverse geocode the given location. Error: \(errorString)")
                completion(nil)
                return
            }
            
            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
            self.reverseGeocodeCache[locationHash] = reversedGeoLocation
            
            completion(reversedGeoLocation)
        }
    }
    
    /**
     Search given address on the map and adds annotations

     - parameter mapView:    The MKMapView reference.
     - parameter address:    The Address string.
     - parameter inRegion:   The Coordinates region.

     - returns void
     */

    public func searchGeocodeAddresses(_ address: String?, inRegion: MKCoordinateRegion, completed: ((Array<MKMapItem>?) -> ())?) {

        guard let address = address else {
            return
        }
        
        let request = MKLocalSearch.Request()

        request.naturalLanguageQuery = address
        request.region = inRegion

        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in

            guard let response = response, error != nil else { return }
            completed?(response.mapItems)
        }
    }
}
