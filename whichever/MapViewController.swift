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
import QuartzCore

class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate, UIViewControllerTransitioningDelegate  {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var zoomButton: UIButton!
    
    var annotations = [MGLPointAnnotation]()
    var notificationToken: NotificationToken?
    var bathrooms = try! Realm().objects(Bathrooms)
    
    let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Reachability
        showNetworkingConnection()
        appdelegate.showActivityIndicator()
        
        //Mapbox MapView
        self.mapView.delegate = self
        self.mapView.userTrackingMode  = MGLUserTrackingMode.FollowWithHeading
        
        //Button Inset
        zoomButton.backgroundColor =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
        zoomButton.layer.cornerRadius = 50/2
        
        //Button Shadow
        zoomButton.layer.shadowColor = UIColor.grayColor().CGColor
        zoomButton.layer.shadowOpacity = 0.5
        zoomButton.layer.shadowRadius = 0
        zoomButton.layer.shadowOffset = CGSizeMake(0, 1.0)
        
        zoomButton.setImage(UIImage(named:"location"), forState: .Normal)
        zoomButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(zoomButton)
        
        //Realm Notifications
        let results = try! Realm().objects(Bathrooms)
        notificationToken = results.addNotificationBlock {[weak self] (changes: RealmCollectionChange <Results<Bathrooms>>) in
            self!.populateMap()
        }
    }
    
    func buttonAction(sender: UIButton!) {
        centerToUsersLocation()
    }
    
    @IBAction func searchButton(sender: AnyObject) {
        performSegueWithIdentifier("about", sender: sender)
    }
    
    func showNetworkingConnection(){
        if ReachabilityManager.sharedInstance.isConnectedToNetwork() {
            print("Connected")
            
        } else {
            
            print("Not Connected")
            let alertController = UIAlertController(title: "Uh-oh!", message: "Check your wifi or cellular settings and restart application.", preferredStyle: .Alert)
            let actionRetry = UIAlertAction(title: "Retry", style: .Default) { (action:UIAlertAction) in
                print("You've pressed the Retry button")
                UIApplication.sharedApplication().keyWindow?.rootViewController = self.storyboard!.instantiateViewControllerWithIdentifier("navigationController")
                let del = UIApplication.sharedApplication().delegate as! AppDelegate
                del.populateInformation()
            }
    
            let settingsButton = UIAlertAction(title: "Settings", style: .Default) { (action:UIAlertAction) in
                print("You've pressed the Setting button")
                
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                let url = settingsUrl
                UIApplication.sharedApplication().openURL(url!, options: [:], completionHandler: nil)
                
                UIApplication.sharedApplication().keyWindow?.rootViewController = self.storyboard!.instantiateViewControllerWithIdentifier("navigationController")
                let del = UIApplication.sharedApplication().delegate as! AppDelegate
                del.populateInformation()
                
            }
            
            alertController.addAction(actionRetry)
            alertController.addAction(settingsButton)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    func populateMap() {
        
        for bathroom in bathrooms {
            let annotation = MGLPointAnnotation()
            let coordinate = CLLocationCoordinate2DMake(bathroom.latitude, bathroom.longitude)
            annotation.coordinate = coordinate
            annotation.title = bathroom.buildingName
            annotation.subtitle = "Availability: \(bathroom.buildingAvailability)"
            annotations.append(annotation)
            self.mapView.addAnnotation(annotation)
            appdelegate.hideActivityIndicator()
        }
    }
    
    @IBAction func menuButtonObj(sender: AnyObject) {
        let newView = self.storyboard!.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        newView.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        self.presentViewController(newView, animated: true, completion: nil)
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
            case "Availability: Public"?: imageName.image = UIImage(named: "green")
            case "Availability: Limited"?: imageName.image = UIImage(named: "orange")
            case "Availability: Limited and Public"?: imageName.image = UIImage(named: "darkBlue")
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
    
    @IBAction func unwindToMapVC(segue:UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "room" ) {
            let controller = segue.destinationViewController as! BuildingViewController
            controller.bathrooms = bathrooms
            controller.buildingName = sender as? String
        }
    }
}

