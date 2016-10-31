//
//  SearchViewController.swift
//  UNC Gender Neutral Bathrooms
//
//  Created by Joseph Hooper on 6/16/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import UIKit
import RealmSwift
import Mapbox

class SearchViewController: UITableViewController {
    
    var searchResults = try! Realm().objects(Buildings)
    var buildings = try! Realm().objects(Buildings).sorted("buildingID", ascending: true)
    var searchController: UISearchController!
    var image = try! Realm().objects(Bathrooms).sorted("image", ascending: true)
    
    var annotation :BuildingsAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up Table View
        let searchResultsController = UITableViewController(style: .Plain)
        searchResultsController.tableView.delegate = self
        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.rowHeight = 65
        searchResultsController.tableView.registerClass(SearchCell.self, forCellReuseIdentifier: "SearchCell")
        
        // Setup  Search Controller
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.barTintColor = UIColor(red: 98/255, green: 159/255, blue: 209/255, alpha: 1.0)
        
        tableView.tableHeaderView?.addSubview(searchController.searchBar)
        let searchBar = searchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for bathrooms"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    @IBAction func unwindToSearchAndBuildingVC(segue:UIStoryboardSegue) {
        
    }
    
    func filterResultsWithSearchString(searchString: String) {
        let predicate = NSPredicate(format: "buildingName CONTAINS [c]%@", searchString)
        let realm = try! Realm()
        searchResults = realm.objects(Buildings).filter(predicate)
    }
    
}
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        filterResultsWithSearchString(searchString)
        let searchResultsController = searchController.searchResultsController as! UITableViewController
        searchResultsController.tableView.reloadData()
        
    }
}

extension SearchViewController:  UISearchBarDelegate {
    
}

extension SearchViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.active && searchController.searchBar.text != "" {
            return searchResults.count
        }
        return buildings.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("SearchCell") as! SearchCell
        
        let building: Buildings
        
        if searchController.active && searchController.searchBar.text != "" {
            building = searchResults[indexPath.row]
        } else {
            building = buildings[indexPath.row]
        }
        
        cell.titleLabel.text = building.buildingName
        cell.subtitleLabel.text = ("Number of Rooms: tbd")
        //\(building.buildingID)")
        
        switch building.buildingAvailability {
        case "Public":
            cell.dbImage.image = UIImage(named: "blue")
        case "Limited":
            cell.dbImage.image = UIImage(named: "orange")
        case "Limited and Public":
            cell.dbImage.image = UIImage(named: "darkblueNote")
        default:
            cell.dbImage.image = UIImage(named: "blue")
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let buildingViewController = storyboard?.instantiateViewControllerWithIdentifier("BuildingViewController") as! BuildingViewController
        
        if (searchController?.searchBar.text?.isEmpty)!{
            buildingViewController.buildingName = buildings[indexPath.row].buildingName
        }else{
            buildingViewController.buildingName = searchResults[indexPath.row].buildingName
        }
        
        navigationController?.pushViewController(buildingViewController, animated: true)
    }
    
}
