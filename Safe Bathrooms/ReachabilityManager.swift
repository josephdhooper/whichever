//
//  ReachabilityManager.swift
//  whichever
//
//  Created by Joseph Hooper on 1/1/17.
//  Copyright © 2017 josephdhooper. All rights reserved.
//  Code below is atributed to douarbou at http://stackoverflow.com/questions/30743408/check-for-internet-connection-in-swift-2-ios-9

import Foundation

enum ReachabilityManagerType {
    case Wifi
    case Cellular
    case None
}

class ReachabilityManager {
    static let sharedInstance = ReachabilityManager()
    
    private var reachability: Reachability!
    private var reachabilityManagerType: ReachabilityManagerType = .None
    
    
    private init() {
        do {
            self.reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ReachabilityManager.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: self.reachability)
        do{
            try self.reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc private func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                self.reachabilityManagerType = .Wifi
            } else {
                self.reachabilityManagerType = .Cellular
            }
        } else {
            self.reachabilityManagerType = .None
        }
    }
}

extension ReachabilityManager {
    
    func isConnectedToNetwork() -> Bool {
        return reachabilityManagerType != .None
    }
    
}
