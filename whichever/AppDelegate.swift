 //
//  AppDelegate.swift
//  whichever
//
//  Created by Joseph Hooper on 5/23/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import UIKit
import Mapbox
import RealmSwift
import Haneke

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var mask: CALayer?
    var imageView: UIImageView?
    var indicator = UIActivityIndicatorView()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
        ReachabilityManager.sharedInstance
        populateInformation()
        addActivityIndicator()
    
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold),NSForegroundColorAttributeName : UIColor.whiteColor()]

        return true
    }

    func addActivityIndicator(){
        indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.height)) as UIActivityIndicatorView
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        indicator.backgroundColor = UIColor.blackColor()
        indicator.alpha = 0.75
    }
    
    func showActivityIndicator(){
        indicator.startAnimating()
        window?.rootViewController?.view.addSubview(indicator)
    }
    func hideActivityIndicator(){
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
    
    func populateInformation(){
        Networking.getData() { data in
            dispatch_async(dispatch_get_main_queue()) {
                guard data != nil else { return }
            }
        }
    
    func applicationWillResignActive(application: UIApplication) {
            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
            // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        }
        
    func applicationDidEnterBackground(application: UIApplication) {
            // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
            // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        }
        
    func applicationWillEnterForeground(application: UIApplication) {
            // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        }
        
    func applicationDidBecomeActive(application: UIApplication) {
            // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        }
        
    func applicationWillTerminate(application: UIApplication) {
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        }
    }
}
