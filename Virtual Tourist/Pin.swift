//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Jordan on 1/13/16.
//  Copyright © 2016 Jordany Abreu. All rights reserved.
//

import MapKit
import CoreData

class Pin: NSManagedObject {
    
    @NSManaged var photos : [Photo]
    @NSManaged var long : NSNumber
    @NSManaged var lat : NSNumber
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(coordinate : CLLocationCoordinate2D, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        self.long = coordinate.longitude as NSNumber
        self.lat = coordinate.latitude as NSNumber
    }
}
