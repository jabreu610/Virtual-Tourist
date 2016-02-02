//
//  Flickr.swift
//  Virtual Tourist
//
//  Created by Jordan on 1/13/16.
//  Copyright © 2016 Jordany Abreu. All rights reserved.
//

import Foundation
import MapKit

class Flickr: NSObject {
    
    typealias CompletionHander = (result: AnyObject!, error: NSError?) -> Void
    
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: All Purpose DataTask
    func taskForResource(arguements: [String : AnyObject], completionHandler: CompletionHander) -> NSURLSessionDataTask {
        
        
        let urlString = Constants.BaseURL + Flickr.escapedParameters(arguements)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let error = downloadError {
                completionHandler(result: nil, error: error)
            } else {
                Flickr.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    func getPathForImageBasedOnLocation(coordinates: CLLocationCoordinate2D, completionHander : (result: [String]?, error: NSError?) -> Void) {
        let mutableArguements = [
            Keys.Method : Methods.Search,
            Keys.Api_Key : Constants.APIKey,
            Keys.BBox : Flickr.createBoundingBoxString(coordinates.latitude, long: coordinates.longitude),
            Keys.SafeSearch : "1",
            Keys.Extras : "url_m",
            Keys.Format : "json",
            Keys.No_JSON_Callback : "1"
        ]
        taskForResource(mutableArguements){JSONResult, error in
            if let error = error {
                print(error)
            } else {
                guard let photosDictionary = JSONResult["photos"] as? NSDictionary else {
                    print("Connot find key 'photos' in \(JSONResult)")
                    return
                }
                guard let photosArray = photosDictionary["photo"] as? [[String : AnyObject]] else {
                    print("Cannot find key 'photo' in \(photosDictionary)")
                    return
                }
                
                var index = 0
                var imageDataArray : [String] = []
                for photos in photosArray {
                    if index < 21 {
                        imageDataArray.append(photos["url_m"] as! String)
                    } else {
                        break
                    }
                    index++
                }
                completionHander(result: imageDataArray, error: nil)
                
            }
            
        }
    }
    
    // MARK: - All purpose task method for images
    
    func taskForImage(filePath: String, completionHandler: (imageData: NSData?, error: NSError?) ->  Void) -> NSURLSessionTask {
        
        let url = NSURL(string: filePath)
                
        let request = NSURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let error = downloadError {
                completionHandler(imageData: nil, error: error)
            } else {
                completionHandler(imageData: data, error: nil)
            }
        }
        
        task.resume()
        
        return task
    }

    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> Flickr {
        
        struct Singleton {
            static var sharedInstance = Flickr()
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: Helper Functions
    
    // Parsing the JSON
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: CompletionHander) {
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        }
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    // Lat/Lon Manipulation
    class func createBoundingBoxString(lat: CLLocationDegrees, long: CLLocationDegrees) -> String {
        
        let range = 0.25
        
        /* Fix added to ensure box is bounded by minimum and maximums */
        let bottom_left_lon = max(long - range, -180.0)
        let bottom_left_lat = max(lat - range, -90.0)
        let top_right_lon = min(long + range, 180.0)
        let top_right_lat = min(lat + range, 90.0)
        
        return "\(bottom_left_lon),\(bottom_left_lat),\(top_right_lon),\(top_right_lat)"
    }
   
    // Escape HTML Parameters
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    // MARK: - Shared Image Cache
    struct Caches {
        static let imageCache = ImageCache()
    }

}
