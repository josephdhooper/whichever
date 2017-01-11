//
//  Bathrooms.swift
//  UNC Gender Neutral Bathrooms
//
//  Created by Joseph Hooper on 7/5/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import Mapbox

class Bathrooms: Object {
    
    dynamic var buildingID = ""
    dynamic var bathroomID = ""
    dynamic var buildingName = ""
    dynamic var floor = ""
    dynamic var roomNumber = ""
    dynamic var signageText = ""
    dynamic var buildingAvailability = ""
    dynamic var roomAvailability = ""
    dynamic var numberOfRooms = ""
    dynamic var details = ""
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
    dynamic var image = ""
    
    var coordinate: CLLocation {
        return CLLocation(latitude: Double(latitude), longitude: Double(longitude));
    }
    override  static func primaryKey() -> String? {
        return "bathroomID"
    }
    
}


    


