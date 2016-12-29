//
//  BuildingTwoViewController.swift
//  whichever
//
//  Created by Joseph Hooper on 12/27/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import UIKit
import RealmSwift

class BuildingTwoViewController: UITableViewController {
    
    var buildingName:String?
    var bathrooms: Results<(Bathrooms)>?
    var image: Results<(Bathrooms)>?
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let buildingNameObj = buildingName{
            bathrooms = try! Realm().objects(Bathrooms).filter("buildingName == '\(buildingNameObj)'").sorted("buildingName", ascending: true)
            image = try! Realm().objects(Bathrooms).sorted("image", ascending: true)
        }
    }
    
    @IBAction func unwindToSearchAndBuildingVC(segue:UIStoryboardSegue) {
        
    }
    
    func completeLabel() {
        
    }
    
    @IBAction func menuButton(sender: AnyObject) {
              let newView = self.storyboard!.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        newView.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        self.presentViewController(newView, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showDetails") {
            let controller = segue.destinationViewController as! DetailsTableViewController
            
            var bathroom: Bathrooms!
            let indexPath = tableView.indexPathForSelectedRow
            if let bathroomsObj = bathrooms{
                bathroom = bathroomsObj[indexPath!.row]
            }
            controller.detailBathroom = bathroom
        }
        
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let bathroomsObj = bathrooms{
            return bathroomsObj.count
        }else{
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BuildingTwoCell") as! BuildingTwoCell
        
        let bathroom: Bathrooms
        if let bathroomsObj = bathrooms{
            bathroom = bathroomsObj[indexPath.row]
            cell.titleLabel.text = bathroom.buildingName
            cell.subTitleLabel.text = ("Room Number: \(bathroom.roomNumber)")
            
            switch bathroom.roomAvailability {
            case "Public":
                cell.dbImage.image = UIImage(named: "green")
            case "Limited":
                cell.dbImage.image = UIImage(named: "orange")
            default:
                cell.dbImage.image = UIImage(named: "green")
            }
        }
        
        return cell
    }
}
