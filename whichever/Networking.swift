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
    
    static func getData (_ completionHandler:@escaping (AnyObject?) -> ()) {
        if let url = URL(string: "https://jdhooper.000webhostapp.com/chData.json") {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let data = data,
                    let dataStore = String(data: data, encoding: String.Encoding.ascii) else {
                        print("Could not find network")
                        completionHandler(nil)
                        return
                }
                
                guard error == nil else {
                    print("Error calling GET")
                    completionHandler(nil)
                    return
                }
                
                let HTTPResponse = response as! HTTPURLResponse
                let statusCode = HTTPResponse.statusCode
                
                if (statusCode == 200) {
                    print("Files from datastore downloaded successfully. \(dataStore)" )
                } else {
                    completionHandler(nil)
                    return
                }
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    completionHandler(json as AnyObject?)
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
                
                })   .resume()
        }
    }
}
