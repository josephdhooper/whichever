//
//  BuildingsAnnotation.swift
//  whichever
//
//  Created by Joseph Hooper on 6/12/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import UIKit
import Mapbox

class BuildingsAnnotation: NSObject, MGLAnnotation {
    
    var customPointAnnotation = CustomPointAnnotation()
    var bathroom: Bathrooms?
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageName = "blueNote"
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, imageName: String, bathroom: Bathrooms? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName

    }
}
