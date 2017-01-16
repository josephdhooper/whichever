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
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var searchResults = try! Realm().objects(Buildings.self)
    var buildings = try! Realm().objects(Buildings.self).sorted(byKeyPath: "buildingID", ascending: true)
    var searchController: UISearchController!
    var image = try! Realm().objects(Bathrooms.self).sorted(byKeyPath: "image", ascending: true)
    var annotation :BuildingsAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //Set up Table View
        let searchResultsController = UITableViewController(style: .plain)
        searchResultsController.tableView.delegate = self
        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.rowHeight = 65
        searchResultsController.tableView.register(SearchCell.self, forCellReuseIdentifier: "SearchCell")
        
        // Setup  Search Controller
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 34/255, green: 167/255, blue: 240/255, alpha: 1.0)
        searchController.searchBar.layer.borderColor = UIColor(red: 34/255, green: 167/255, blue: 240/255, alpha: 1.0).cgColor
        searchController.searchBar.layer.borderWidth = 1.00

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
    
    @IBAction func unwindToSearchVC(_ segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func menuButtonObj(_ sender: AnyObject) {
        let newView = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        newView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(newView, animated: true, completion: nil)
    }

    func filterResultsWithSearchString(_ searchString: String) {
        let predicate = NSPredicate(format: "buildingName CONTAINS [c]%@", searchString)
        let realm = try! Realm()
        searchResults = realm.objects(Buildings.self).filter(predicate)
    }
}
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        filterResultsWithSearchString(searchString)
        let searchResultsController = searchController.searchResultsController as! UITableViewController
        searchResultsController.tableView.reloadData()
    }
}

extension SearchViewController:  UISearchBarDelegate {
    
}

extension SearchViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return searchResults.count
        }
        return buildings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
        
        let building: Buildings
        
        if searchController.isActive && searchController.searchBar.text != "" {
            building = searchResults[indexPath.row]
        } else {
            building = buildings[indexPath.row]
        }
        
        cell.titleLabel.text = building.buildingName
        //cell.subtitleLabel.text = building.buildingAvailability +
        cell.subtitleLabel.text = ("No. of Rooms: \(building.numberOfRooms)")
        
        switch building.buildingAvailability {
        case "Public":
            cell.dbImage.image = UIImage(named: "green")
        case "Limited":
            cell.dbImage.image = UIImage(named: "orange")
        case "Limited and Public":
            cell.dbImage.image = UIImage(named: "darkBlue")
        default:
            cell.dbImage.image = UIImage(named: "purple")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let buildingViewController = storyboard?.instantiateViewController(withIdentifier: "BuildingTwoViewController") as! BuildingTwoViewController
        
        if (searchController?.searchBar.text?.isEmpty)!{
            buildingViewController.buildingName = buildings[indexPath.row].buildingName
        } else {
            buildingViewController.buildingName = searchResults[indexPath.row].buildingName
        }
        navigationController?.pushViewController(buildingViewController, animated: true)
    
        
    }

}
