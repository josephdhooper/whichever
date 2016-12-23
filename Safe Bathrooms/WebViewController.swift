//
//  WebViewController.swift
//  whichever
//
//  Created by Joseph Hooper on 12/21/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAddress()
        webView.delegate = self
    }
    
    func loadAddress(){
        let requestURL = NSURL(string: "https://jdhooper.wixsite.com/whicheverapp")
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
        
    }
    
    
    func webViewDidStartLoad(webView: UIWebView){
        activityController.startAnimating()
        print("Starting")
    }
    
    func webViewDidFinishLoad(webView : UIWebView){
        activityController.stopAnimating()
        print("Finish")
        
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        activityController.stopAnimating()
        let alertController = UIAlertController(title: "Uh-oh!", message: "Something's wrong. Check your wifi or cellular connection.", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction) in
            print("You've pressed OK button");
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion:nil)
        
    }
    
    @IBAction func menuButtonObj(sender: AnyObject) {
   
        let newView = self.storyboard!.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        newView.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        self.presentViewController(newView, animated: true, completion: nil)
    }
    
    
}

