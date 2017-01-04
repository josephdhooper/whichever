//
//  DBManager.swift
//  whichever
//
//  Created by Joseph Hooper on 12/9/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager: NSObject {

    func saveDBItem (bathroom: Bathrooms) {
        let realm  = try! Realm()
        try! realm.write {
            realm.add(bathroom)
        }
    }
    
    func getDBItems() -> [Bathrooms] {
        let dbItemsFromRealm  = try! Realm().objects(Bathrooms)
        var bathroom = [Bathrooms]()
        
        if dbItemsFromRealm.count > 0 {
            for dbItemsInRealm in dbItemsFromRealm {
                let bathrooms = dbItemsInRealm as Bathrooms
                bathroom.append(bathrooms)
            }
        }
        
        return bathroom
    }
}
