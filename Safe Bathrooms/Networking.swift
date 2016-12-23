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
        //if let url = NSURL(string: "https://jdhooper.000webhostapp.com/chData.json") {
        
        if let url = NSURL(string: "https://gist.githubusercontent.com/josephdhooper/d4c305e57670907874ee72dad77cdc37/raw/39ae629e192d648a1bb07f988a410e93088c3e48/spaces.json") {
             NSURLSession.sharedSession().dataTaskWithURL(url)  { (data, response, error) in
                
                guard let data = data,
                    let dataStore = String(data: data, encoding: NSASCIIStringEncoding) else {
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
                    print("Files from datastore downloaded successfully. \(dataStore)" )
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
                    }
                    
                } catch {
                    print("Error: \(error)")
                    completionHandler(nil)
                }
                
                } .resume()
        }
    }
}
