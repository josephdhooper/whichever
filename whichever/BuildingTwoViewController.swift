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
        
//        if let buildingNameObj = buildingName{
//            bathrooms = try! Realm().objects(Bathrooms()).filter("buildingName == '\(buildingNameObj)'").sorted(byKeyPath: "buildingName", ascending: true)
//            image = try! Realm().objects(Bathrooms()).sorted(byKeyPath: "image", ascending: true)
//        }
    }
    
    @IBAction func unwindToSearchAndBuildingVC(segue:UIStoryboardSegue) {
        
    }
    
    func completeLabel() {
        
    }
    
    @IBAction func menuButton(sender: AnyObject) {
        let newView = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        newView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(newView, animated: true, completion: nil)
    }
    
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showDetails") {
            let controller = segue.destination as! DetailsTableViewController
            
            var bathroom: Bathrooms!
            let indexPath = tableView.indexPathForSelectedRow
            if let bathroomsObj = bathrooms{
                bathroom = bathroomsObj[indexPath!.row]
            }
            controller.detailBathroom = bathroom
        }
        
    }
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let bathroomsObj = bathrooms{
            return bathroomsObj.count
        }else{
            return 0
        }
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingTwoCell") as! BuildingTwoCell
        
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
