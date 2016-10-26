//
//  DistanceViewController.swift.swift
//  whichever
//
//  Created by Joseph Hooper on 9/30/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import UIKit
import Mapbox
import RealmSwift
import Polyline

class DistanceViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    
    var spaces: Results<Bathrooms>?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func unwindToBuildingDetails(segue:UIStoryboardSegue) {
        
    }
    
}