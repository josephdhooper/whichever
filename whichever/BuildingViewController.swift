//
//  BuildingViewController.swift
//  whichever
//
//  Created by Joseph Hooper on 9/22/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import UIKit
import RealmSwift

class BuildingViewController: UITableViewController {
    
    var buildingName:String?
    var bathrooms: Results<(Bathrooms)>?
    var image: Results<(Bathrooms)>?
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let buildingNameObj = buildingName{
            bathrooms = try! Realm().objects(Bathrooms.self).filter("buildingName == '\(buildingNameObj)'").sorted(byKeyPath: "buildingName", ascending: true)
            image = try! Realm().objects(Bathrooms.self).sorted(byKeyPath: "image", ascending: true)
        }
    }
    
    @IBAction func unwindToSearchAndBuildingVC(_ segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func menuButtonObj(_ sender: AnyObject) {
        let newView = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        newView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(newView, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "showDetail") {
            let controller = segue.destination as! DetailsTableViewController
            
            var bathroom: Bathrooms!
            let indexPath = tableView.indexPathForSelectedRow
            if let bathroomsObj = bathrooms{
                bathroom = bathroomsObj[indexPath!.row]
            }
            controller.detailBathroom = bathroom
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let bathroomsObj = bathrooms{
            return bathroomsObj.count
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell") as! BuildingCell
        
        let bathroom: Bathrooms
        if let bathroomsObj = bathrooms{
            bathroom = bathroomsObj[indexPath.row]
            cell.titleLabel.text = bathroom.buildingName
            cell.subtitleLabel.text = ("Room Number: \(bathroom.roomNumber)")
            
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
