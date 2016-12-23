//
//  DirectionsTableViewController.swift
//  whichever
//
//  Created by Joseph Hooper on 10/24/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import RealmSwift

class DirectionsTableViewController: UITableViewController {
    
    internal var steps = [RouteStep]()
    
    let formattedTravelTime = String()
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    
}
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    @IBAction func menuButtonObj(sender: AnyObject) {
        let newView = self.storyboard!.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        newView.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        self.presentViewController(newView, animated: true, completion: nil)
    }
    
    func loadData() {
        
    }
    
    override func tableView(_tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("DirectionsCell") as! DirectionsCell
        cell.mainLabel?.text = steps[indexPath.row].instructions
        
        let distanceFormatter = NSLengthFormatter()
        let formattedDistance = distanceFormatter.stringFromMeters(steps[indexPath.row].distance)
        cell.subLabel?.text = "- \(formattedDistance) -"
        
        if let directions = steps[indexPath.row].maneuverDirection {
            switch directions {
            case .StraightAhead :
                cell.directionImage.image = UIImage(named: "forward")
            case .SharpLeft :
                cell.directionImage.image = UIImage(named: "hardLeft")
            case .SharpRight :
                cell.directionImage.image = UIImage(named: "hardRight")
            case .SlightLeft :
                cell.directionImage.image = UIImage(named: "slightLeft")
            case .SlightRight :
                cell.directionImage.image = UIImage(named: "slightRight")
            case .Left :
                cell.directionImage.image = UIImage(named: "left")
            case .Right :
                cell.directionImage.image = UIImage(named: "right")
            case .UTurn :
                cell.directionImage.image = UIImage(named: "uTurn")
            default:
                cell.directionImage.image = UIImage(named: "marker")
                
            }
            
            if let direction = steps[indexPath.row].maneuverType  {
                switch direction {
                case .Arrive :
                    cell.directionImage.image = UIImage(named: "arrived")
                case .Continue :
                    cell.directionImage.image = UIImage(named: "forward")
                case .TakeRoundabout :
                    cell.directionImage.image = nil
                case .TurnAtRoundabout :
                    cell.directionImage.image = nil
                case .Depart :
                    cell.directionImage.image = nil
                case .TakeOffRamp :
                    cell.directionImage.image = UIImage(named: "ramp")
                case .TakeOnRamp :
                    cell.directionImage.image = UIImage(named: "ramp")
                default: break
                
                }
            }
        }
        
        return cell
    }
}
