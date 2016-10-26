//
//  LoadViewController.swift
//  whichever
//
//  Created by Joseph Hooper on 7/13/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import UIKit
import RealmSwift

class LoadViewController: UIViewController {
    let realm = try! Realm()
    var bathrooms: Results<Bathrooms>?
    
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    @IBOutlet weak var roundedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityController.startAnimating()
        populateInformation()
    }
    func populateInformation(){
        roundedButton.hidden = false
        Networking.getData() { data in
            dispatch_async(dispatch_get_main_queue()) {
                self.activityController.stopAnimating()
                guard data != nil else {
                    self.roundedButton.hidden = true
                    dispatch_async(dispatch_get_main_queue()) {
                        let alertController = UIAlertController(title: "Network Error", message: "No Internet Connection\nTry again?", preferredStyle: .Alert)
                        
                        let actionYes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (action) in
                            self.populateInformation()
                            self.activityController.startAnimating()
                            
                        }
                        let actionNo = UIAlertAction(title: "No", style: .Default) { (action:UIAlertAction) in
                            print("You've pressed No button");
                        }
                        
                        alertController.addAction(actionYes)
                        alertController.addAction(actionNo)
                        self.presentViewController(alertController, animated: true, completion:nil)
                        self.activityController.stopAnimating()
                        
                    }
                    return
                }
            }
        }
    }
    
    @IBAction func loadMap(sender: AnyObject) {
        performSegueWithIdentifier("mapView", sender: nil)
    }
}

