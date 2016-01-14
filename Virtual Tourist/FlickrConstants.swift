//
//  FlickrConstants.swift
//  Virtual Tourist
//
//  Created by Jordan on 1/13/16.
//  Copyright © 2016 Jordany Abreu. All rights reserved.
//

import Foundation

extension Flickr {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URL
        static let baseURL : String = "https://api.flickr.com/services/rest/"
        
        // MARK: API Key
        static let APIKey : String = "d68e3126bb9d0d1dda7d39cb7f22ec50"
    }
    
    // MARK: Methods
    struct Methods {
        
        static let search : String = "flicker.photos.search"
        
    }
    
}
