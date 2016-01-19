//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Jordan on 1/13/16.
//  Copyright © 2016 Jordany Abreu. All rights reserved.
//

import MapKit

class Pin: NSObject, MKAnnotation {
    
    struct Keys {
        
    }
    
    var photos : [Photo] = [Photo]()
    var coordinate : CLLocationCoordinate2D
    
    init(coordinate : CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
