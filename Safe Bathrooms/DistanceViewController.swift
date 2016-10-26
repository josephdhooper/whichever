//
//  DistanceViewController.swift.swift
//  whichever
//
//  Created by Joseph Hooper on 9/30/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import UIKit
import Mapbox
import RealmSwift
import Polyline
import MapboxDirections
import CoreLocation

class DistanceViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var routeLine: MGLPolyline = MGLPolyline()
    var annotation = [MGLPointAnnotation]()
    var latitude: Double?
    var longitude: Double?
    var buildingName:String?
    var bathrooms: Results<(Bathrooms)>?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        destinationPoint()
        mapView.delegate = self
    }
    
    
    @IBAction func segmentControl(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: mapView.styleURL = MGLStyle.darkStyleURLWithVersion(9)
        case 1: mapView.styleURL = MGLStyle.lightStyleURLWithVersion(9)
        case 2: mapView.styleURL = MGLStyle.outdoorsStyleURLWithVersion(9)
        default: mapView.styleURL = MGLStyle.darkStyleURLWithVersion(9)
            
        }
    }
    
    func destinationPoint() {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        annotation.title = buildingName
        mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(mapView: MGLMapView, calloutViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        return nil
    }
    
    @IBAction func unwindToBuildingDetails(segue:UIStoryboardSegue) {
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        let waypoints = [Waypoint(coordinate: CLLocationCoordinate2D (latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude), name: "StartPoint"),
                         Waypoint(coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), name: "EndPoint"),]
        
        let options = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifierWalking)
        options.includesSteps = true
        
        Directions(accessToken: "pk.eyJ1IjoiamRob29wZXIiLCJhIjoiY2ltNWZibjYxMDFrMHU0bTY0ZmhkbDN1ZiJ9.QfG6ts2mzoZIg13N-JqMSQ").calculateDirections(options: options) { (waypoints, routes, error) in
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            
            if let route = routes?.first, let leg = route.legs.first {
                print("Route via \(leg):")
                
                let distanceFormatter = NSLengthFormatter()
                let formattedDistance = distanceFormatter.stringFromMeters(route.distance)
                
                let travelTimeFormatter = NSDateComponentsFormatter()
                travelTimeFormatter.unitsStyle = .Short
                let formattedTravelTime = travelTimeFormatter.stringFromTimeInterval(route.expectedTravelTime)
                
                print("Distance: \(formattedDistance); ETA: \(formattedTravelTime!)")
                
                for step in leg.steps {
                    print("\(step.instructions)")
                    if step.distance > 0 {
                        let formattedDistance = distanceFormatter.stringFromMeters(step.distance)
                        print("— \(formattedDistance) —")
                    }
                }
                
                if route.coordinateCount > 0 {
                    // Convert the route’s coordinates into a polyline.
                    var routeCoordinates = route.coordinates!
                    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    
                    // Add the polyline to the map and fit the viewport to the polyline.
                    self.mapView.addAnnotation(routeLine)
                    self.mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0), animated: true)
                    
                }
            }
            
        }
    }
}
