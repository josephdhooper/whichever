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
    case walking = 0
    case cycling = 1
}
class DistanceViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var routeLine: MGLPolyline = MGLPolyline()
    var annotation = [MGLPointAnnotation]()
    var latitude: Double?
    var longitude: Double?
    var buildingName:String?
    var bathrooms: Results<(Bathrooms)>?
    var selectedRouteType = RouteType.walking
    var steps: [RouteStep]?
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var mapView: MGLMapView!
    
    fileprivate let segueId = "showList"
    
    let directions = Directions.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.userTrackingMode = .followWithCourse
        
        //showNetworkingConnection()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        destinationPoint()
        mapView.delegate = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        segmentedControl.frame = CGRect(x: segmentedControl.frame.origin.x, y: segmentedControl.frame.origin.y, width: segmentedControl.frame.size.width, height: 28)
    }
    
    func showNetworkingConnection(){
        if currentReachabilityStatus != .notReachable {
            print("Connected")
            
        } else {
            let alertController = UIAlertController(title: "Uh-oh!", message: "ETA can't be calculated. Check your wifi or cellular connection.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                print("You've pressed OK button")
                
            }
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueId {
            if let directionsVC = segue.destination as? DirectionsTableViewController{
                if let steps = steps {
                    directionsVC.steps = steps
                }else{
                    print("No direction available")
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == segueId {
            if steps != nil{
                return true
            } else {
                return false
            }
        } else {
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
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> UIView? {
        return nil
    }
    
    func updateRoute(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        let waypoints = [Waypoint(coordinate: CLLocationCoordinate2D (latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude), name: "StartPoint"), Waypoint(coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), name: "EndPoint"),]
        
        var routeOptions:RouteOptions?
        
        switch selectedRouteType {
        case RouteType.walking:
            routeOptions = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifierWalking)
            print("Walking")
        case RouteType.cycling:
            routeOptions = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifierCycling)
            print("Cylcing")
        }
        
        if let options = routeOptions{
            options.includesSteps = true
            
            _ = directions.calculate(options) { (waypoints, routes, error) in

                guard error == nil else {
                    print("Error calculating directions: \(error!)")
                    return
                }
                
                if let route = routes?.first, let leg = route.legs.first {
                    print("Route via \(leg):")
                    
                    let distanceFormatter = LengthFormatter()
                    let formattedDistance = distanceFormatter.string(fromMeters: route.distance)
                    
                    let travelTimeFormatter = DateComponentsFormatter()
                    travelTimeFormatter.unitsStyle = .short
                    let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)
                    
                    print ("Distance: \(formattedDistance)")
                    print ("ETA: \(formattedTravelTime!)")
                    
                    self.distanceLabel.text = "Estimated travel time: \(formattedTravelTime!)"
                    
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
                        
                        self.mapView.addAnnotation(self.routeLine)
                        self.mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0), animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func IBActionBack(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateRoute(manager, didUpdateLocations: locations)
    }
    
    @IBAction func segmentControl(_ sender: AnyObject) {
        switchRouteStyle()
    }
    
    @IBAction func unwindToDistanceVC(_ segue:UIStoryboardSegue) {
        
    }
    
}
