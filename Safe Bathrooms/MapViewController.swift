//
//  MapViewController.swift
//  whichever
//
//  Created by Joseph Hooper on 5/23/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//
//
import UIKit
import Mapbox
import CoreLocation
import RealmSwift

class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    var annotations = [MGLPointAnnotation]()
    var bathrooms = try! Realm().objects(Bathrooms)
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateMap()
        self.mapView.userTrackingMode  = MGLUserTrackingMode.FollowWithHeading
        
    }
    
    @IBAction func searchButton(sender: AnyObject) {
        performSegueWithIdentifier("about", sender: sender)
        
    }
    
    func populateMap() {
        for bathroom in bathrooms {
            let annotation = MGLPointAnnotation()
            let coordinate = CLLocationCoordinate2DMake(bathroom.latitude, bathroom.longitude)
            annotation.coordinate = coordinate
            annotation.title = bathroom.buildingName
            annotation.subtitle = "Availability: \(bathroom.buildingAvailability)"
            annotations.append(annotation)
            mapView.delegate = self
            mapView.addAnnotations(annotations)
        }
    }
    
    @IBAction func unwindToMap(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func centerToUserLocationTapped(sender: AnyObject) {
        centerToUsersLocation()
    }
    
    func centerToUsersLocation() {
        let center = mapView.userLocation!.coordinate
        mapView.setCenterCoordinate(center, zoomLevel: 15, animated: true)
    }
    
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        return nil
    }
    
    func mapView(mapView: MGLMapView, leftCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        
        let imageName = UIImageView()
        imageName.frame = (frame: CGRectMake(0, 0, 50, 50))
        
        if let subtitle = annotation.subtitle {
            switch subtitle {
            case "Availability: Public"?: imageName.image = UIImage(named: "blueNote")
            case "Availability: Limited"?: imageName.image = UIImage(named: "orangeNote")
            case "Availability: Limited and Public"?: imageName.image = UIImage(named: "darkblueNote")
            default: return nil
                
            }
            self.view.addSubview(imageName)
            return imageName
        }
        
        return nil
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(mapView: MGLMapView, rightCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .DetailDisclosure)
    }
    
    func mapView(mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        performSegueWithIdentifier("room", sender: annotation.title!)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "room" )
        {
            let controller = segue.destinationViewController as! BuildingViewController
            controller.bathrooms = bathrooms
            controller.buildingName = sender as? String
            
        }
    }
}
