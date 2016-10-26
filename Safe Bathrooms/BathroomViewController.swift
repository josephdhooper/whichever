
//
//  BathroomViewController.swift
//  UNC Gender Neutral Bathrooms
//
//  Created by Joseph Hooper on 7/5/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//  Insights from HackerNews.com helped to create the BathroomViewController

import UIKit
import RealmSwift
import QuartzCore
import Haneke

class BathroomViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var roomDetails: UITextField!
    @IBOutlet weak var floorNumber: UITextField!
    @IBOutlet weak var room: UITextField!
    @IBOutlet weak var signageInfo: UITextField!
    @IBOutlet weak var availability: UIImageView!
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    @IBOutlet var scrollView: UIScrollView!
    
    var bathrooms = try! Realm().objects(Bathrooms)
    var latitudeObj = Double?()
    var longitudeObj = Double?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        imageView.clipsToBounds = true
        activityController.startAnimating()
        populationDirections()
        self.configureView()
        
    }

    func unFillTextFields(){
        let realm = try! Realm()
        if (roomDetails.text!.isEmpty) {
            realm.beginWrite()
            detailBathroom?.details = roomDetails.text!
            try! realm.commitWrite()
            
        }
    }
    
    func validateFields() -> Bool {
        if (roomDetails.text!.isEmpty) {
            let alertController = UIAlertController(title: "Validation Error", message: "Add bathroom details. You can add to existing details, too. ", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: {(alert : UIAlertAction) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
            alertController.addAction(alertAction)
            presentViewController(alertController, animated: true, completion: nil)
            
            return false
            
        } else {
            
            return true
        }
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        unFillTextFields()
        return true
        
    }
    
    @IBAction func addDetails(sender: AnyObject) {
        validateFields()
        let realm = try! Realm()
        realm.beginWrite()
        detailBathroom?.details = roomDetails.text!
        try! realm.commitWrite()
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffset = self.scrollView.contentOffset.y * 0.05
        let availableOffset = min(yOffset, 300)
        let contentRectYOffset = availableOffset / imageView.frame.size.height
        imageView.layer.contentsRect = CGRectMake(0.0, contentRectYOffset, 1, 1)
    }
    
    @IBAction func unwindToBuildingDetails(segue:UIStoryboardSegue) {
        
    }
    var detailBathroom: Bathrooms? {
        didSet {
            self.configureView()
        }
    }
    
    func populationDirections(){
        if let detailBathroom = detailBathroom {
            if let
                latitudeObj = latitudeObj,
                longitudeObj = longitudeObj
                
            {
                latitudeObj.distanceTo(detailBathroom.latitude)
                longitudeObj.distanceTo(detailBathroom.longitude)
            }
        }
    }
    
    func configureView() {
        if let detailBathroom = detailBathroom {
            if let
                name = name,
                room = room,
                floorNumber = floorNumber,
                signageInfo = signageInfo,
                roomDetails = roomDetails,
                availability = availability
                
            {
                name.text = detailBathroom.buildingName
                room.text = detailBathroom.roomNumber
                floorNumber.text = detailBathroom.floor
                signageInfo.text = detailBathroom.signageText
                roomDetails.text = detailBathroom.details
                availability.image = UIImage(named: detailBathroom.roomAvailability)
                
                switch detailBathroom.roomAvailability {
                case "Public":
                    availability.image = UIImage(named: "blue")
                case "Limited":
                    availability.image = UIImage(named: "orange")
                default:
                    availability.image = UIImage(named: "blue")
                }
                dispatch_async(dispatch_get_main_queue()) {
                    if let url = NSURL(string: detailBathroom.image) {
                        self.imageView.hnk_setImageFromURL(url, placeholder: nil, success: { (image) -> Void in
                            self.imageView.image = image
                            self.activityController.stopAnimating()
                            }, failure: { (error) -> Void in
                                self.imageView.image = UIImage(named: "noPicture")
                                self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
                                self.activityController.stopAnimating()
                                let alertController = UIAlertController(title: "Network Error", message: "No Internet Connection.", preferredStyle: .Alert)
                                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction) in
                                    print("You've pressed OK button");
                                }
                                alertController.addAction(OKAction)
                                self.presentViewController(alertController, animated: true, completion:nil)
                        })
                    }
                    return
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDirections" {
            let controller = segue.destinationViewController as! DistanceViewController
            controller.latitude = detailBathroom?.latitude
            controller.longitude = detailBathroom?.longitude
            controller.buildingName = detailBathroom?.buildingName
        }
    }
    
}


