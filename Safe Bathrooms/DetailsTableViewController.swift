//
//  DetailsTableViewController.swift
//  whichever
//
//  Created by Joseph Hooper on 11/16/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//  Followed tutorial on http://blog.matthewcheok.com/design-teardown-stretchy-headers/

import UIKit
import RealmSwift
import QuartzCore
import Haneke

private let headerHeight: CGFloat = 200

class DetailsTableViewController: UITableViewController {
    
    var imageView: UIImageView!
    var headerView: UIView!
    var newHeaderLayer: CAShapeLayer!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var floorNumber: UILabel!
    @IBOutlet weak var signageInfo: UILabel!
    @IBOutlet weak var roomDetails: UILabel!
    @IBOutlet weak var availabilityIcon: UIImageView!
    @IBOutlet var buttonObj: UIButton!
    
    var bathrooms = try! Realm().objects(Bathrooms)
    var latitudeObj = Double?()
    var longitudeObj = Double?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonObj.layer.borderColor = UIColor( red: 34/255, green: 167/255, blue: 240/255, alpha: 1.0 ).CGColor
        buttonObj.layer.borderWidth = 1.0
        buttonObj.layer.cornerRadius = 4
       
        populationDirections()
        self.configureView()
        activityIndicator.startAnimating()
        updateView()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        setNewView()
    }
    
    @IBAction func menuButtonObj(sender: AnyObject) {
        let newView = self.storyboard!.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        newView.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        self.presentViewController(newView, animated: true, completion: nil)
    }
    
    func updateView(){
        
        tableView.backgroundColor = UIColor.whiteColor()
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.addSubview(headerView)
        
        newHeaderLayer = CAShapeLayer()
        newHeaderLayer.fillColor = UIColor.blackColor().CGColor
        headerView.layer.mask = newHeaderLayer
        
        let newHeight = headerHeight
        tableView.contentInset = UIEdgeInsets(top: newHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -newHeight)
        setNewView()
    }
    
    func setNewView(){
        
        let newHeight = headerHeight
        var getHeaderFrame =  CGRect(x: 0, y: -newHeight, width: tableView.bounds.width, height:headerHeight)
        
        if tableView.contentOffset.y < newHeight {
            
            getHeaderFrame.origin.y = tableView.contentOffset.y
            getHeaderFrame.size.height = -tableView.contentOffset.y
        }
        
        headerView.frame = getHeaderFrame
        let cutDirection = UIBezierPath()
        cutDirection.moveToPoint(CGPoint(x: 0, y: 0))
        cutDirection.addLineToPoint(CGPoint(x: getHeaderFrame.width, y: 0))
        cutDirection.addLineToPoint(CGPoint(x: getHeaderFrame.width, y: getHeaderFrame.height))
        cutDirection.addLineToPoint(CGPoint(x: 0, y: getHeaderFrame.height))
        newHeaderLayer.path = cutDirection.CGPath
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    @IBAction func loadRoute(sender: AnyObject) {
        performSegueWithIdentifier("showDirections", sender: nil)
        
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
                availabilityIcon = availabilityIcon
            {
                name.text = detailBathroom.buildingName
                room.text = detailBathroom.roomNumber
                floorNumber.text = detailBathroom.floor
                signageInfo.text = detailBathroom.signageText
                roomDetails.text = detailBathroom.details
                availabilityIcon.image = UIImage(named: detailBathroom.roomAvailability)
                
                switch detailBathroom.roomAvailability {
                case "Public":
                    availabilityIcon.image = UIImage(named: "green")
                case "Limited":
                    availabilityIcon.image = UIImage(named: "orange")
                default:
                    availabilityIcon.image = UIImage(named: "darkBlue")
                }
                dispatch_async(dispatch_get_main_queue()) {
                    if let url = NSURL(string: detailBathroom.image) {
                        self.imageView.hnk_setImageFromURL(url, placeholder: nil, success: { (image) -> Void in
                            self.imageView.image = image
                            self.activityIndicator.stopAnimating()
                            }, failure: { (error) -> Void in
                                self.imageView.image = UIImage(named: "noPicture")
                                self.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
                              self.activityIndicator.stopAnimating()
                                let alertController = UIAlertController(title: "Uh-oh!", message: "Something's wrong. Check your wifi or cellular connection.", preferredStyle: .Alert)
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
