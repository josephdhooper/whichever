
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
    
   
    @IBOutlet var headerLabels: [UILabel]!
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var roomDetails: UILabel!
    
    @IBOutlet weak var floorNumber: UILabel!
    @IBOutlet weak var signageInfo: UILabel!
  
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var availability: UIImageView!
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    var bathrooms = try! Realm().objects(Bathrooms)
    var latitudeObj = Double?()
    var longitudeObj = Double?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        activityController.startAnimating()
        imageView.clipsToBounds = true
        
        imageView.layer.frame = CGRectInset(imageView!.layer.frame, 0, 0 )
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.backgroundColor = UIColor.whiteColor()
        imageView.layer.cornerRadius = 1.0
        imageView.layer.borderWidth = 0
        
        populationDirections()
        self.configureView()
        
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffset = self.scrollView.contentOffset.y * 0.05
        let availableOffset = min(yOffset, 300)
        let contentRectYOffset = availableOffset / imageView.frame.size.height
        imageView.layer.contentsRect = CGRectMake(0.0, contentRectYOffset, 1, 1)
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

    @IBAction func unwindToBathroomVC(segue:UIStoryboardSegue) {
        
    }
    
}


