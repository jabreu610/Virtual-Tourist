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
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressPinDrop = UILongPressGestureRecognizer(target: self, action: "pinDrop:")
        longPressPinDrop.minimumPressDuration = 0.25
        mapView.addGestureRecognizer(longPressPinDrop)
        mapView.delegate = self
    }
    
    // MARK: Actions
    func pinDrop(gRecognizer : UIGestureRecognizer) -> Void {
        if gRecognizer.state != .Began {
            return
        }
        let touchPoint = gRecognizer.locationInView(self.mapView)
        let touchMapCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        
        let annotation = Pin(coordinate: touchMapCoordinate)
        prefetchImages(annotation)
        locations.append(annotation)
        mapView.addAnnotation(annotation)
    }
    
    func prefetchImages(pin: Pin){
        Flickr.sharedInstance().searchForSingleImageBaseOnLocation(pin.coordinate) { Results, error in
            if let error = error{
                print(error)
            } else {
                for imageData in Results! {
                    let photo = Photo(path: imageData)
                    print(imageData)
                    pin.photos.append(photo)
                }
            }
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
            if location == view.annotation as! Pin {
                break;
            } else {
                index++
            }
        }
        controller.pin = self.locations[index]
        self.navigationController!.pushViewController(controller, animated: true)
    }
}