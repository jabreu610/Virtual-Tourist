//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Jordan on 1/13/16.
//  Copyright © 2016 Jordany Abreu. All rights reserved.
//

import Foundation
import UIKit

class Photo {
    
    var imagePath : String?
    var pin : Pin?
    
    init(path: String){
        imagePath = path
    }
    
    var image : UIImage? {
        get { return Flickr.Caches.imageCache.imageWithIdentifier(imagePath) }
        set { Flickr.Caches.imageCache.storeImage(newValue, withIdentifier: imagePath!) }
    }

}
