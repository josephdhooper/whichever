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
import Haneke


class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate, UIViewControllerTransitioningDelegate  {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var zoomButton: UIButton!
    
    var annotations = [MGLPointAnnotation]()
    var notificationToken: NotificationToken?
    var bathrooms = try! Realm().objects(Bathrooms.self)
    var image: Results<(Bathrooms)>?
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Reachability
        showNetworkingConnection()
        appdelegate.showActivityIndicator()
        
        //Mapbox MapView
        self.mapView.delegate = self
        self.mapView.userTrackingMode  = .followWithHeading
        
        //Button Inset
        zoomButton.backgroundColor =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
        zoomButton.layer.cornerRadius = 50/2
        
        //Button Shadow
        zoomButton.layer.shadowColor = UIColor.gray.cgColor
        zoomButton.layer.shadowOpacity = 0.5
        zoomButton.layer.shadowRadius = 0
        zoomButton.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        
        zoomButton.setImage(UIImage(named:"location"), for: UIControlState())
        zoomButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(zoomButton)
        
        //Realm Notifications
        let results = try! Realm().objects(Bathrooms.self)
        notificationToken = results.observe {[weak self] (changes: RealmCollectionChange <Results<Bathrooms>>) in
            self!.populateMap()
        }
    }
    
    func buttonAction(_ sender: UIButton!) {
        centerToUsersLocation()
    }
    
    @IBAction func searchButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "about", sender: sender)
    }
    
    func showNetworkingConnection(){
        if currentReachabilityStatus != .notReachable {
            print("Connected")
            
        } else {
            
            print("Not Connected")
            let alertController = UIAlertController(title: "Uh-oh!", message: "Check your wifi or cellular settings and restart application.", preferredStyle: .alert)
            let actionRetry = UIAlertAction(title: "Retry", style: .default) { (action:UIAlertAction) in
                print("You've pressed the Retry button")
                UIApplication.shared.keyWindow?.rootViewController = self.storyboard!.instantiateViewController(withIdentifier: "navigationController")
                let del = UIApplication.shared.delegate as! AppDelegate
                del.populateInformation()
            }
            
            let settingsButton = UIAlertAction(title: "Settings", style: .default) { (action:UIAlertAction) in
                print("You've pressed the Setting button")
                
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                let url = settingsUrl
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                
                UIApplication.shared.keyWindow?.rootViewController = self.storyboard!.instantiateViewController(withIdentifier: "navigationController")
                let del = UIApplication.shared.delegate as! AppDelegate
                del.populateInformation()
                
            }
            
            alertController.addAction(actionRetry)
            alertController.addAction(settingsButton)
            self.present(alertController, animated: true, completion: nil)
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
    
    @IBAction func menuButtonObj(_ sender: AnyObject) {
        let newView = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        newView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(newView, animated: true, completion: nil)
    }
    
    func centerToUsersLocation() {
        let center = mapView.userLocation!.coordinate
        mapView.setCenter(center, zoomLevel: 15, animated: true)
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        
        let imageName = UIImageView()
        imageName.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
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
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
        
    }
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .detailDisclosure)
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "room", sender: annotation.title!)
        
    }
    
    @IBAction func unwindToMapVC(_ segue:UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "room" ) {
            let controller = segue.destination as! BuildingViewController
            controller.bathrooms = bathrooms
            controller.buildingName = sender as? String
        }
    }
}

