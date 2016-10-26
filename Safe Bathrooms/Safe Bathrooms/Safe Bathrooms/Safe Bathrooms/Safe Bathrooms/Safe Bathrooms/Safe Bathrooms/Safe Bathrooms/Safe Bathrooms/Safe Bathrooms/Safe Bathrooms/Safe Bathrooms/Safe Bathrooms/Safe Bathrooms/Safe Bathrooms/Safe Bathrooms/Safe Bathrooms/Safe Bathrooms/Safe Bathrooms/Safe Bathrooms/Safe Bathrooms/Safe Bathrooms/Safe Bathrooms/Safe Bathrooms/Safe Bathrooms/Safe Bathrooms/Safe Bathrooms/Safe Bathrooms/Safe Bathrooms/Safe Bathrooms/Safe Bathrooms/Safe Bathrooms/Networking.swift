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
        
        //Initiate session to call REST GET/API
        let requestURL: NSURL = NSURL(string: "https://gist.githubusercontent.com/josephdhooper/d4c305e57670907874ee72dad77cdc37/raw/eb3f21628f16cadd0b25abb8771c5bdd71c392de/spaces.json")!
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
    
        //Create GET call
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
            
            //Prepare for potential errors: According to w3schools.com -> http://www.w3schools.com/tags/ref_httpmessages.asp <- the 200 status code indicates an OK transfer.
            let HTTPResponse = response as! NSHTTPURLResponse
            let statusCode = HTTPResponse.statusCode
            
            if (statusCode == 200) {
                print("Files from datastore downloaded successfully.")
            } else {
                completionHandler(nil)
                return
            }
            
            //Begin error handleing with do-catch statement
            do {
                
                // For JSON response data deserialization
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                completionHandler(json)
                let spaces = (json as! NSDictionary)["spaces"] as! [NSDictionary]
                
                //Set up to write files to Realm mobile database
                let realm = try! Realm()
                try! realm.write {
                    
                    // Save the object in each element of the array
                    for space in spaces {
                        
                        //Write files to to Realm mobile database
                        realm.create(Bathrooms.self, value: space, update: true)
                        realm.create(Buildings.self, value: space, update: true)
                        
                    }
                    
                    //Print files to defualt location on hardrive: Users/username/Library/Developer/CoreSimulator/Devices/location number/data/Containers/Data/Application/location number/Documents/default.realm
                    print(Realm.Configuration.defaultConfiguration.fileURL!)
                }
                
            } catch {
                print("Error: \(error)")
                completionHandler(nil)
            }
        }
        
        //Start task
        task.resume()
    }
    
}

