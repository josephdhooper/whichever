//
//  Buildings.swift
//  whichever
//
//  Created by Joseph Hooper on 9/26/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//


import UIKit
import Foundation
import RealmSwift

class Buildings: Object {
    
    dynamic var buildingName = ""
    dynamic var buildingAvailability = "" 
    dynamic var buildingID = ""
    
    override  static func primaryKey() -> String? {
        return "buildingName"
    }
    
}

