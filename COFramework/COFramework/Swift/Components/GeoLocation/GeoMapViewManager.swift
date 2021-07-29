//
//  GeoMapViewManager.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import MapKit
import CloudKit
import Foundation

public class GeoMapViewManager: NSObject {

    public static var mapMovedEvent: Signal = Signal()
    public static var mapMovedByUserEvent: Signal = Signal()
    public static var mapMarkerSelectedEvent: SignalData<GeoModel> = SignalData()
    
    public var mapView: MKMapView?
    
    public var centerAnnotationView: MKPinAnnotationView?
    public var saveLastPosition: Bool = false
    
    public var currentLocation: CLLocation? {
        return self.mapView?.userLocation.location
    }
    
    public var centerLocation: CLLocation? {
        guard let latitude = mapView?.centerCoordinate.latitude, let longitude = mapView?.centerCoordinate.longitude else {
            return nil
        }
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    /**
     init method to prepare mapView

     - parameter mapView:    The MKMapView reference.
     - parameter saveLastPosition:  Flag to save last position of the maps location and radius
     - returns void
     */

    public init(_ mapView: MKMapView, saveLastPosition: Bool = false, delegate: MKMapViewDelegate?) {
        super.init()
        
        self.saveLastPosition = saveLastPosition
        self.centerAnnotationView = MKPinAnnotationView()
        
        self.mapView = mapView
        self.mapView?.showsUserLocation = false
        self.mapView?.delegate = delegate
    }
    
    /**
     mapCenterLocationAndRadius method returns current mapView's center location and radius

     - returns (CLLocation, CLLocationDistance)
     */

    
    public func mapCenterLocationAndRadius() -> (CLLocation, CLLocationDistance)? {
        
        guard let mapView = self.mapView else {
            return nil
        }
        
        let fixedLocation = mapView.centerCoordinate
        
        let location = CLLocation(latitude: fixedLocation.latitude, longitude: fixedLocation.longitude)
        
        let k: CGFloat = mapView.frame.size.width / mapView.frame.size.height
        let radius = mapView.currentRadius * Double(k)
        
        return (location, radius)
    }
    
    /**
     Shows user location on the mapView
     */

    public func showUserLocation(show: Bool = true) {
        self.mapView?.showsUserLocation = show
    }
    
    /**
     distanceToLocation - Calculate Distance from current location to CLLocationCoordinate2D

     - parameter locatioin:  CLLocation
     - returns distance : CLLocationDistance distance between locations
     */

    public func distanceToLocation(fromLocation: CLLocation?, _ toLocation: CLLocation?) -> CLLocationDistance? {
        
        guard let fromLocation = fromLocation,
            let toLocation  = toLocation else {
            return nil
        }

        let distance = toLocation.distance(from: fromLocation)

        return distance
    }

    /**
     Remove annotations from mapView
     */

    public func removeAnnotations() {
        if let annotations = mapView?.annotations {
            mapView?.removeAnnotations(annotations)
        }
    }

    // MARK: Public MapView methods
    
    /**
     Add annotation pin to the center of the map

     - parameter
     - returns void
     */

    public func addCenterPin() {
        guard let centerAnnotationView = self.centerAnnotationView else {
            return
        }
        
        // remove previously added pins
        self.removeCenterPin()
        
        // set annotaion view
        self.centerAnnotationView?.pinTintColor = .red

        // add to the mapview
        self.mapView?.addSubview(centerAnnotationView)
        
        // set center
        self.updatePin()
    }
    
    /**
     remove pin annotation

     - parameter
     - returns void
     */
    
    public func removeCenterPin() {
        guard let subviews = self.mapView?.subviews else {
            return
        }
        
        // remove previously added notations
        for view in subviews {
            if let annotationView = view as? MKPinAnnotationView {
                annotationView.removeFromSuperview()
            }
        }
    }
    
    /**
     Move recenter pin after zoom/region change

     - parameter
     - returns void
     */
    
    public func updatePin() {
        guard let mapView = self.mapView, let centerCoordinate = self.mapView?.centerCoordinate,
            let mapViewPoint = self.mapView?.convert(centerCoordinate, toPointTo: mapView) else {
            return
        }

        // set center og the pin
        self.centerAnnotationView?.center = CGPoint(x: mapViewPoint.x + 8, y: mapViewPoint.y - 16)
    }
    
    /**
     Add annotations to given mapItems

     - parameter mapItems:   MKMapItem object as an Array
     - returns void
     */

    public func addAnnotations(_ mapItems: Array<MKMapItem>) {

        for item in mapItems {

            let annotation = MKPointAnnotation()

            annotation.coordinate = item.placemark.coordinate
            annotation.title = item.name
            annotation.subtitle = item.placemark.title

            mapView?.addAnnotation(annotation)
        }
    }

    /**
     Add annotation to given GeoModel

     - parameter geoModel:   GeoModel object to add
     - returns void
     */

    public func addAnnotation(_ geoModel: GeoModel) {
        mapView?.addAnnotation(geoModel)
    }
    
    /**
     Show annotation to given GeoModels array

     - parameter geoModel:   GeoModel array
     - returns void
     */

    public func showAnnotation() {
        if let annotations = mapView?.annotations {
            mapView?.showAnnotations(annotations, animated: true)
        }
    }

    // MARK: Overlay methods

    /**
     Add overlay to given GeoModel

     - parameter geoModel:  GeoModel object stores coordinate and radius
     - parameter radius:  CLLocationDistance to be zoom in
     - returns void
     */

    public func addRadiusOverlay(_ geoModel: GeoModel, radius: CLLocationDistance) {
        self.addRadiusOverlay(geoModel.coordinate, radius: radius, lineWidth: nil, strokeColor: nil, fillColor: nil)
    }

    /**
     Add overlay to given coordinate, radius and circleRenderedInfo

     - parameter coordinate:  CLLocationCoordinate2D to coordinate
     - parameter radius:  CLLocationDistance to be zoom in
     - parameter circleRenderedInfo:  circleRenderedInfo
     - returns void
     */

    public func addRadiusOverlay(_ coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, lineWidth: CGFloat?, strokeColor: UIColor?, fillColor: UIColor?) {
        mapView?.addOverlay(GeoCircleOverlay(center: coordinate, radius: radius, lineWidth: lineWidth, strokeColor: strokeColor, fillColor: fillColor))
    }
    
    /**
     addRadiusOverlayToCurrentLocation add radius circle
     this will be used for geofencing to show where is the
     in and out radius on the display

     - parameter mapView:  MKMapView object that's being used
     - parameter identifier:  String to identify current overlay
     - parameter title:  String title for annotation view
     - parameter subtitle:  String subtitle for annotation view
     - parameter note:  String note will be used to notify user with custom message

     - returns void
     */

    public func addRadiusOverlayToCurrentLocation(nibName: String, title: String?, subtitle: String?, data: AnyObject?) {

        if let coordinate = self.currentLocation?.coordinate {

            let geoModel = GeoModel(nibName: nibName, coordinate: coordinate, title: title, subtitle: subtitle, data: data)
            self.addRadiusOverlay(geoModel, radius: 10000)
        }
    }
    
    /**
     removeRadiusOverlays

     - parameter
     - returns void
     */
    
    public func removeRadiusOverlays() {
        guard let overlays = self.mapView?.overlays else {
            return
        }
        
        // remove previously added notations
        for overlay in overlays {
            self.mapView?.removeOverlay(overlay)
        }
    }

    /**
     addAnnotationToLocation add annotation to current location
     on the map

     - parameter nibName:  String to View's nibName current overlay
     - parameter coordinate:  CLLocationCoordinate2D to coordinate
     - parameter title:  String title for annotation view
     - parameter subtitle:  String subtitle for annotation view
     - parameter post:  PostModek object

     - returns void
     */

    public func addAnnotationToLocation(nibName: String?, coordinate: CLLocationCoordinate2D?, title: String?, subtitle: String?, data: AnyObject?) {

        if let coordinate = coordinate {
            let geoModel = GeoModel(nibName: nibName, coordinate: coordinate, title: title, subtitle: subtitle, data: data)
            self.addAnnotation(geoModel)
        }
    }
    
    /**
     addAnnotationToCurrentLocation add annotation to current location
     on the map

     - parameter nibName:  String to View's nibName current overlay
     - parameter coordinate:  CLLocationCoordinate2D to coordinate
     - parameter title:  String title for annotation view
     - parameter subtitle:  String subtitle for annotation view
     - parameter post:  PostModek object

     - returns void
     */

    public func addAnnotationToCurrentLocation(nibName: String, title: String?, subtitle: String?, data: AnyObject?) {

        if let coordinate = self.currentLocation?.coordinate {
            let geoModel = GeoModel(nibName: nibName, coordinate: coordinate, title: title, subtitle: subtitle, data: data)
            self.addAnnotation(geoModel)
        }
    }

    // MARK: Zoom methods
    
    /**
     zoomWithMeters to users current location with mile
     
     - parameter meters:  Double value of the unit
     - returns void
     */
    
    public func zoomWithMeters(meters: Double, animated: Bool = true) {
        self.zoomToMapCenterLocationInMapView(meters: meters, animated: animated)
    }

    /**
     Zoom to users current location
     - returns void
     */

    public func zoomToUserLocationInMapView(meters: CLLocationDistance = 10000, animation: Bool = true) {
        if let coordinate = self.currentLocation?.coordinate {
            let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: meters, longitudinalMeters: meters)
            mapView?.setRegion(region, animated: animation)
        }
    }
    
    /**
     Zoom to users current location
     - returns void
     */

    public func zoomToMapCenterLocationInMapView(meters: CLLocationDistance = 10000, animated: Bool = true) {
        guard let (location, _) = self.mapCenterLocationAndRadius() else {
            return
        }
        
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: meters, longitudinalMeters: meters)
        mapView?.setRegion(region, animated: animated)
    }

    /**
     Zoom to custom location for given GeoModel

     - parameter geoModel:  GeoModel object stores coordinate and radius
     - returns void
     */

    public func zoomToCustomLocationInMapView(_ geoModel: GeoModel, radius: CLLocationDistance) {
        self.zoomToCustomLocationInMapView(geoModel.coordinate, radius: radius)
    }

    /**
     Zoom to custom location for given params

     - parameter coordinate:  CLLocationCoordinate2D to be zoom in
     - parameter radius:  CLLocationDistance to be zoom in
     - returns void
     */

    public func zoomToCustomLocationInMapView(_ coordinate: CLLocationCoordinate2D?, radius: CLLocationDistance = 10000, animated: Bool = true) {
        
        guard let coordinate = coordinate else {
            return
        }
        
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        
        runOnMainQueue {
            self.mapView?.setRegion(region, animated: animated)
        }
    }

    /**
     openInMap method for opening default map in device

     - parameter mapView:  MKMapView object to apply custom annotation
     - parameter title:  String for selected location Title value

     - returns void
     */

    public func openInMap(_ mapView: MKMapView, title: String) {

        guard let coordinate = self.currentLocation?.coordinate else {
            return
        }

        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: coordinate),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: mapView.region.span)
        ]

        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)

        mapItem.name = title
        mapItem.openInMaps(launchOptions: options)
    }
}
