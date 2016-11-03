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

enum RouteType:Int {
    case Driving = 0
    case Cycling = 1
    case Walking = 2
}

class DistanceViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var routeLine: MGLPolyline = MGLPolyline()
    var annotation = [MGLPointAnnotation]()
    var latitude: Double?
    var longitude: Double?
    var buildingName:String?
    var bathrooms: Results<(Bathrooms)>?
    var selectedRouteType = RouteType.Driving
    var steps: [RouteStep]?
    
    private let segueId = "showList"
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueId{
            if let directionsVC = segue.destinationViewController as? DirectionsTableViewController{
                if let steps = steps{
                    directionsVC.steps = steps
                }else{
                    print("No direction available")
                }
                print(directionsVC)
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == segueId{
            if let steps = steps{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func switchRouteStyle(){
        selectedRouteType = RouteType.init(rawValue: segmentedControl.selectedSegmentIndex)!
        locationManager.startUpdatingLocation()
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
    
    func updateRoute(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        let waypoints = [Waypoint(coordinate: CLLocationCoordinate2D (latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude), name: "StartPoint"),
                         Waypoint(coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), name: "EndPoint"),]
        
        var routeOptions:RouteOptions?
        
        switch selectedRouteType {
        case RouteType.Driving:
            routeOptions = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifierAutomobile)
            print("Driving")
        case RouteType.Cycling:
            routeOptions = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifierCycling)
            print("Cycling")
        case RouteType.Walking:
            routeOptions = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifierWalking)
            print("Walking")
        default:
            routeOptions = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifierAutomobile)
            print("Driving")
        }
        
        if let options = routeOptions{
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
                    
                    self.steps = leg.steps
                    
                    if route.coordinateCount > 0 {
                        var routeCoordinates = route.coordinates!
                        
                        // Convert the route’s coordinates into a polyline.
                        if let annotations = self.mapView.annotations{
                            for annotation in annotations{
                                if annotation is MGLPolyline{
                                    self.mapView.removeAnnotation(annotation)
                                }
                            }
                        }
                        
                        
                        self.routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                        
                        // Add the polyline to the map and fit the viewport to the polyline.
                        self.mapView.addAnnotation(self.routeLine)
                        self.mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0), animated: true)
                        
                    }
                }
                
            }
        }
    }
    
  
    @IBAction func IBActionBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateRoute(manager, didUpdateLocations: locations)
    }

    @IBAction func segmentControl(sender: AnyObject) {
        switchRouteStyle()
    }
    
    @IBAction func unwindToDistanceVC(segue:UIStoryboardSegue) {
        
    }

}
