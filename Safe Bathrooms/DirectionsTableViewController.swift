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
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func tableView(_tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("DirectionsCell") as! DirectionsCell
        
        //let object = objects[indexPath.row]
        //cell.textLabel!.text = object.description
    
        return cell
    }
    
}

