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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        populateInformation()
        addActivityIndicator()
        
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold),NSForegroundColorAttributeName : UIColor.white]
        
        
        return true
    }
    
    func addActivityIndicator(){
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height)) as UIActivityIndicatorView
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        indicator.backgroundColor = UIColor.black
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
            DispatchQueue.main.async {
                guard data != nil else { return }
            }
        }
        
        func applicationWillResignActive(_ application: UIApplication) {
            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
            // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        }
        
        func applicationDidEnterBackground(_ application: UIApplication) {
            // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
            // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        }
        
        func applicationWillEnterForeground(_ application: UIApplication) {
            // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        }
        
        func applicationDidBecomeActive(_ application: UIApplication) {
            // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        }
        
        func applicationWillTerminate(_ application: UIApplication) {
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        }
        
        func applicationDidReceiveMemoryWarning(application: UIApplication) {
            URLCache.shared.removeAllCachedResponses()
            URLCache.shared.diskCapacity = 0
            URLCache.shared.memoryCapacity = 0
        }
    }
 }
