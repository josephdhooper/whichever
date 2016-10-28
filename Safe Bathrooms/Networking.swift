//
//  Networking.swift
//  whichever
//
//  Created by Joseph Hooper on 7/16/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit
import Haneke

class Networking: NSObject {
    
    static func getData (completionHandler:(AnyObject?) -> ()) {
        let requestURL: NSURL = NSURL(string: "https://gist.githubusercontent.com/josephdhooper/d4c305e57670907874ee72dad77cdc37/raw/eb3f21628f16cadd0b25abb8771c5bdd71c392de/spaces.json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) { data, response, error in
            
            guard let data = data else {
                print("Could not find network")
                completionHandler(nil)
                return
            }
            
            guard error == nil else {
                print("Error calling GET")
                completionHandler(nil)
                return
            }
            
            let HTTPResponse = response as! NSHTTPURLResponse
            let statusCode = HTTPResponse.statusCode
            
            if (statusCode == 200) {
                print("Files from datastore downloaded successfully.")
            } else {
                completionHandler(nil)
                return
            }
            
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                completionHandler(json)
                let spaces = (json as! NSDictionary)["spaces"] as! [NSDictionary]
                
                let realm = try! Realm()
                try! realm.write {
                    
                    for space in spaces {
                        realm.create(Bathrooms.self, value: space, update: true)
                        realm.create(Buildings.self, value: space, update: true)
                    }
                    print(Realm.Configuration.defaultConfiguration)
//                    print(Realm.Configuration.defaultConfiguration.fileURL!)
                }
                
            } catch {
                print("Error: \(error)")
                completionHandler(nil)
            }
        }
        
        task.resume()
    }
}

