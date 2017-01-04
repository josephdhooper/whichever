//
//  MenuViewController.swift
//  whichever
//
//  Created by Joseph Hooper on 12/19/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class MenuViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    let menuManager = MenuManager()
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = self.menuManager
        dismissButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        
            }
    
    @IBAction func sendEmail(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["consciousraisingapps@gmail.com"])
        mailComposerVC.setSubject("I have a question")
        mailComposerVC.setMessageBody("Sending questions...", isHTML: false)
        
        return mailComposerVC
        
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Uh-oh!", message: "Your device could not send e-mail. Check your e-mail configuration and try again.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func websiteButton(sender: AnyObject) {
        let url = NSURL(string: "http://consciousraisingapps.wixsite.com/allgender")
        UIApplication.sharedApplication().openURL(url!, options: [:], completionHandler: nil)
        
    }

        func buttonAction(sender: UIButton!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
}



