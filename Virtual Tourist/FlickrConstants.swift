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
        static let BaseURL : String = "https://api.flickr.com/services/rest/"
        
        // MARK: API Key
        static let APIKey : String = "d68e3126bb9d0d1dda7d39cb7f22ec50"
    }
    
    // MARK: Methods
    struct Methods {
        static let Search : String = "flickr.photos.search"
    }
    
    // MARK: Keys
    struct Keys {
        static let Method : String = "method"
        static let Api_Key : String = "api_key"
        static let BBox : String = "bbox"
        static let SafeSearch : String = "safe_search"
        static let Extras : String = "extras"
        static let Format : String = "format"
        static let No_JSON_Callback : String = "nojsoncallback"
        static let PerPage : String = "per_page"
        static let Page : String = "page"
    }
    
}
