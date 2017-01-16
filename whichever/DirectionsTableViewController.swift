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
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    @IBAction func menuButtonObj(_ sender: AnyObject) {
        let newView = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        newView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(newView, animated: true, completion: nil)
    }
    
    override func tableView(_ _tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DirectionsCell") as! DirectionsCell
        cell.mainLabel?.text = steps[indexPath.row].instructions
        
        let distanceFormatter = LengthFormatter()
        let formattedDistance = distanceFormatter.string(fromMeters: steps[indexPath.row].distance)
        cell.subLabel?.text = "- \(formattedDistance) -"
        
        cell.directionImage.image = UIImage(named: "marker")
        
        if let directions = steps[indexPath.row].maneuverDirection {
            switch directions {
            case .straightAhead :
                cell.directionImage.image = UIImage(named: "forward")
            case .sharpLeft :
                cell.directionImage.image = UIImage(named: "hardLeft")
            case .sharpRight :
                cell.directionImage.image = UIImage(named: "hardRight")
            case .slightLeft :
                cell.directionImage.image = UIImage(named: "slightLeft")
            case .slightRight :
                cell.directionImage.image = UIImage(named: "slightRight")
            case .left :
                cell.directionImage.image = UIImage(named: "left")
            case .right :
                cell.directionImage.image = UIImage(named: "right")
            case .uTurn :
                cell.directionImage.image = UIImage(named: "uTurn")
                
            }
            
            if let directions = steps[indexPath.row].maneuverType {
                switch directions {
                case .arrive :
                    cell.directionImage.image = UIImage(named: "arrived")
                default:break
                    
                }
            }
        }
        
        return cell
        
    }
}
