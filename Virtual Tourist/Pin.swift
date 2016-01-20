//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Jordan on 1/13/16.
//  Copyright © 2016 Jordany Abreu. All rights reserved.
//

import MapKit

class Pin: NSObject {
    
    struct Keys {
        
    }
    
    var photos : [Photo] = [Photo]()
    var long : NSNumber
    var lat : NSNumber
    
    init(coordinate : CLLocationCoordinate2D) {
        self.long = coordinate.longitude as NSNumber
        self.lat = coordinate.latitude as NSNumber
    }
}
