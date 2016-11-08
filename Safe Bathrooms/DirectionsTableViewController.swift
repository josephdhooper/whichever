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
import Realm
import RealmSwift


class DirectionsTableViewController: UITableViewController {
    
    internal var steps = [RouteStep]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return steps.count
    }
    
    override func tableView(_tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("DirectionsCell") as! DirectionsCell
        cell.textLabel?.text = steps[indexPath.row].instructions
        
        let distanceFormatter = NSLengthFormatter()
        let formattedDistance = distanceFormatter.stringFromMeters(steps[indexPath.row].distance)
        cell.detailTextLabel?.text = "- \(formattedDistance) -"
    
    
        return cell
    }
    
}

