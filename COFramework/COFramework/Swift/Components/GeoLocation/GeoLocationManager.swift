//
//  GeoLocationManager.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import COFramework

class GeoLocationManager: NSObject, CLLocationManagerDelegate {

    /// Location objects
    var locationManager: CLLocationManager?
    var location: CLLocation?
    
    //
    // MARK: - sharedInstance for singleton access
    //
    static let sharedInstance: GeoLocationManager = GeoLocationManager()

    //MARK: LocationManager Functions
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        
        self.locationManagerStart()
    }
    
    func requestWhenInUseAuthorization() {
        // request when in use authorizatioin
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManagerStart() {
        //start updating location
        self.locationManager?.startUpdatingLocation()
        
        Logger.sharedInstance.LogDebug("Location services started...")
    }
    
    func locationManagerStop() {
        self.locationManager?.stopUpdatingLocation()
        
        Logger.sharedInstance.LogDebug("Location services stopped...")
    }
    
    //MARK: clLocationManager Delegate Function
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .restricted || status == .denied {
            self.showAlert()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            self.location = lastLocation
        }
    }
    
    //MARK: helper Functions
    
    func isLocationAvailable() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                    self.requestWhenInUseAuthorization()
                    return false
                case .restricted, .denied:
                    Logger.sharedInstance.LogDebug("Location services denied/restricted by user...")
                    return false
                case .authorizedWhenInUse, .authorizedAlways:
                    Logger.sharedInstance.LogDebug("Location services granted by user..")
                    return true
                default:
                    Logger.sharedInstance.LogDebug("Location services undefined response..")
                    return false
            }
        }
        
        self.showAlert()
        
        return false
    }
    
    //
    // Not in use for now
    //
    
    func showAlert() {
        let alert = UIAlertController(title: "Location sharing required".localize(),
                                      message: "You need to allow Location Services to continue".localize(),
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Settings".localize(), style: .default) { (_) in
            
            #if targetEnvironment(macCatalyst)
                let settingsURL = URL(fileURLWithPath: "x-apple.systempreferences:com.apple.preference")
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            #else
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            #endif
        })
        
        alert.addAction(UIAlertAction(title: "OK".localize(), style: .cancel, handler: nil))
        
        NotificationsCenterManager.sharedInstance.post("PRESENT", userInfo: ["viewController": alert])
    }
}
