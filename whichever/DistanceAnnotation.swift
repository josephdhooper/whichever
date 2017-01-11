//
//  DistanceAnnotation.swift
//  whichever
//
//  Created by Joseph Hooper on 9/30/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections

class DistanceAnnotation: NSObject, MGLAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var bathroom: Bathrooms?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, imageName: String, bathroom: Bathrooms? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle

    }
}



