//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Jordan on 1/13/16.
//  Copyright © 2016 Jordany Abreu. All rights reserved.
//

import MapKit

class Pin: NSObject, MKAnnotation {
    
    
    @objc var coordinate : CLLocationCoordinate2D
    var photos : Photo?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    

}
