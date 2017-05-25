//
//  DetailsTableViewController.swift
//  whichever
//
//  Created by Joseph Hooper on 11/16/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//  Followed tutorial on http://blog.matthewcheok.com/design-teardown-stretchy-headers/

import UIKit
import RealmSwift
import QuartzCore
import Haneke
import MessageUI

private let headerHeight: CGFloat = 200

class DetailsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var imageView: UIImageView!
    var headerView: UIView!
    var newHeaderLayer: CAShapeLayer!
    var bathrooms = try! Realm().objects(Bathrooms.self)
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var suggestions: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var floorNumber: UILabel!
    @IBOutlet weak var signageInfo: UILabel!
    @IBOutlet weak var roomDetails: UILabel!
    @IBOutlet weak var availabilityIcon: UIImageView!
    @IBOutlet var buttonObj: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showNetworkingConnection()
        
        buttonObj.layer.borderColor = UIColor( red: 34/255, green: 167/255, blue: 240/255, alpha: 1.0 ).cgColor
        buttonObj.layer.borderWidth = 1.0
        buttonObj.layer.cornerRadius = 4
        
        self.configureView()
        activityIndicator.startAnimating()
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func showNetworkingConnection(){
        if currentReachabilityStatus != .notReachable {
            print("Connected")
            self.buttonObj.isUserInteractionEnabled = true
            
        } else {
            print("Not Connected")
            self.buttonObj.isUserInteractionEnabled = false
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNewView()
    }
    
    @IBAction func menuButtonObj(_ sender: AnyObject) {
        let newView = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        newView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(newView, animated: true, completion: nil)
    }
    
    @IBAction func addSuggestions(_ sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["consciousraisingapps@gmail.com"])
        mailComposerVC.setSubject("I have a suggestion")
        mailComposerVC.setMessageBody("Sending suggestions...", isHTML: false)
        
        return mailComposerVC
        
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Uh-oh!", message: "Your device could not send e-mail. Check your e-mail configuration and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        self.present(alert, animated: true){}
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func updateView(){
        
        tableView.backgroundColor = UIColor.white
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.addSubview(headerView)
        
        newHeaderLayer = CAShapeLayer()
        newHeaderLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = newHeaderLayer
        
        let newHeight = headerHeight
        tableView.contentInset = UIEdgeInsets(top: newHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -newHeight)
        setNewView()
    }
    
    func setNewView(){
        
        let newHeight = headerHeight
        var getHeaderFrame =  CGRect(x: 0, y: -newHeight, width: tableView.bounds.width, height:headerHeight)
        
        if tableView.contentOffset.y < newHeight {
            
            getHeaderFrame.origin.y = tableView.contentOffset.y
            getHeaderFrame.size.height = -tableView.contentOffset.y
        }
        
        headerView.frame = getHeaderFrame
        let cutDirection = UIBezierPath()
        cutDirection.move(to: CGPoint(x: 0, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeaderFrame.width, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeaderFrame.width, y: getHeaderFrame.height))
        cutDirection.addLine(to: CGPoint(x: 0, y: getHeaderFrame.height))
        newHeaderLayer.path = cutDirection.cgPath
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    @IBAction func loadRoute(_ sender: AnyObject) {
        performSegue(withIdentifier: "showDirections", sender: nil)
        
    }
    
    var detailBathroom: Bathrooms? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        if let detailBathroom = detailBathroom {
            if let
                name = name,
                let room = room,
                let floorNumber = floorNumber,
                let signageInfo = signageInfo,
                let roomDetails = roomDetails,
                let availabilityIcon = availabilityIcon
                
            {
                name.text = detailBathroom.buildingName
                room.text = detailBathroom.roomNumber
                floorNumber.text = detailBathroom.floor
                signageInfo.text = detailBathroom.signageText
                roomDetails.text = detailBathroom.details
                availabilityIcon.image = UIImage(named: detailBathroom.roomAvailability)
                
                switch detailBathroom.roomAvailability {
                case "Public":
                    availabilityIcon.image = UIImage(named: "green")
                case "Limited":
                    availabilityIcon.image = UIImage(named: "orange")
                default:
                    availabilityIcon.image = UIImage(named: "darkBlue")
                }
                DispatchQueue.main.async {
                    if let url = URL(string: detailBathroom.image) {
                        self.imageView.hnk_setImageFromURL(url, placeholder: nil, failure: { (error) -> Void in
                                let alertController = UIAlertController(title: "Uh-oh!", message: "Check your wifi or cellular connection.", preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                                    print("You've pressed OK button")
                                    self.imageView.image = UIImage(named: "noPicture")
                                    self.imageView.contentMode = UIViewContentMode.scaleAspectFill
                                    self.activityIndicator.stopAnimating()
                                    self.showNetworkingConnection()
                                    
                                }
                                
                                alertController.addAction(OKAction)
                                self.present(alertController, animated: true, completion: nil)
                        }, success: { (image) ->
                            Void in
                            self.imageView.image = image
                                                     
                            self.activityIndicator.stopAnimating()
                            })
                    }
                    return
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDirections" {
            let controller = segue.destination as! DistanceViewController
            controller.latitude = detailBathroom?.latitude
            controller.longitude = detailBathroom?.longitude
            controller.buildingName = detailBathroom?.buildingName
            

        }
    }
    
    @IBAction func unwindToBathroomVC(_ segue:UIStoryboardSegue) {
        
    }
}
