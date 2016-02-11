//
//  TravelLocationVC.swift
//  Virtual Tourist
//
//  Created by Jordan on 1/13/16.
//  Copyright © 2016 Jordany Abreu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationVC: UIViewController, MKMapViewDelegate {
    
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    var locations = [Pin]()
    
    
    // MARK: - Core Data Convenience
    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    

    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressPinDrop = UILongPressGestureRecognizer(target: self, action: "pinDrop:")
        longPressPinDrop.minimumPressDuration = 0.25
        mapView.addGestureRecognizer(longPressPinDrop)
        mapView.delegate = self
        locations = fetchAllPins()
        restoreFetchedPins(locations)
    }
    
    // MARK: Actions
    func pinDrop(gRecognizer : UIGestureRecognizer) -> Void {
        if gRecognizer.state != .Began {
            return
        }
        let touchPoint = gRecognizer.locationInView(self.mapView)
        let touchMapCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        
        let pin = Pin(coordinate: touchMapCoordinate, context: self.sharedContext)
        prefetchImages(pin)
        locations.append(pin)
        mapView.addAnnotation(pin)
        self.saveContext()
    }
    
    func prefetchImages(pin: Pin){
        Flickr.sharedInstance().getPathForImageBasedOnLocation(pin.coordinate) { Results, error in
            if let error = error{
                print(error)
            } else {
                for imageData in Results! {
                    _ = Photo(path: imageData, pin: pin, context: self.sharedContext)
                    self.saveContext()
                }
            }
        }
    }
    
    func fetchAllPins() -> [Pin] {
        
        // Create the Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        // Execute the Fetch Request
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
        } catch  let error as NSError {
            print("Error in fetchAllPins(): \(error)")
            return [Pin]()
        }
    }
    
    func restoreFetchedPins(locations: [Pin]){
        for pin in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(pin.lat as Double, pin.long as Double)
            mapView.addAnnotation(annotation)
        }
    }

    
    
    // MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        for view in views {
            let mkView = view
            
            // Check if current annotation is inside visible map rect, else go to next one
            let point:MKMapPoint  =  MKMapPointForCoordinate(mkView.annotation!.coordinate);
            if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
                continue;
            }
            
            let endFrame:CGRect = mkView.frame;
            
            // Move annotation out of view
            mkView.frame = CGRectMake(mkView.frame.origin.x, mkView.frame.origin.y - self.view.frame.size.height, mkView.frame.size.width, mkView.frame.size.height);
            
            // Animate drop
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations:{() in
                mkView.frame = endFrame
                // Animate squash
                }, completion:{(Bool) in
                    UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:{() in
                        mkView.transform = CGAffineTransformMakeScale(1.0, 0.6)
                        
                        }, completion: {(Bool) in
                            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:{() in
                                mkView.transform = CGAffineTransformIdentity
                                }, completion: nil)
                    })
                    
            })
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("PhotoAlbumVC") as! PhotoAlbumVC
        var index : Int = 0
        for location in self.locations {
            if location.long == view.annotation?.coordinate.longitude && location.lat == view.annotation?.coordinate.latitude {
                break;
            } else {
                index++
            }
        }
        controller.pin = self.locations[index]
        mapView.deselectAnnotation(view.annotation, animated: false)
        self.navigationController!.pushViewController(controller, animated: true)
    }
}