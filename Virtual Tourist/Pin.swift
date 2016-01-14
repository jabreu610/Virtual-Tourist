//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Jordan on 1/13/16.
//  Copyright © 2016 Jordany Abreu. All rights reserved.
//

import MapKit
import CoreData

class Pin: NSManagedObject, MKAnnotation {
    
    struct Keys {
        static let Coordinate = "coordinate"
        static let Photos = "photos"
    }
    
    @NSManaged var coordinate : CLLocationCoordinate2D
    @NSManaged var photos : [Photo]
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        coordinate = dictionary[Keys.Coordinate] as! CLLocationCoordinate2D
    }

}
