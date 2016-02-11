//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Jordan on 1/13/16.
//  Copyright © 2016 Jordany Abreu. All rights reserved.
//

import CoreData
import UIKit

class Photo : NSManagedObject {
    
    @NSManaged var imagePath : String?
    @NSManaged var pin : Pin?
    @NSManaged var id : String?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(path: String, pin: Pin, identifier: String, context: NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        imagePath = path
        self.pin = pin
        id = identifier
    }
    
    var image : UIImage? {
        get { return Flickr.Caches.imageCache.imageWithIdentifier(id) }
        set { Flickr.Caches.imageCache.storeImage(newValue, withIdentifier: id!) }
    }

}
