//
//  PhotoAlbumVC.swift
//  Virtual Tourist
//
//  Created by Jordan on 1/13/16.
//  Copyright © 2016 Jordany Abreu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

let reuseIdentifier = "collectionViewCell"

class PhotoAlbumVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    // NARK: Properties
    var pin: Pin!
    
    
    // MARK: - Core Data Convenience
    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "pin == %@", self.pin);
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.scrollEnabled = false
        mapView.zoomEnabled = false
        mapView.rotateEnabled = false
        do {
            try fetchedResultsController.performFetch()
        } catch {}
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(pin.lat as Double, pin.long as Double), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(pin.lat as Double, pin.long as Double)
        mapView.addAnnotation(annotation)
        
        if pin.photos.isEmpty {
            Flickr.sharedInstance().getPathForImageBasedOnLocation(CLLocationCoordinate2DMake(pin.lat as Double, pin.long as Double)) { Results, error in
                if let error = error{
                    print(error)
                } else {
                    for imageData in Results! {
                        _ = Photo(path: imageData["imageURLString"]!, pin: self.pin, identifier: imageData["id"]!, context: self.sharedContext)
                    }
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.collectionView.reloadData()
                }
                self.saveContext()
            }
        }
        
    }
    
    // MARK: Actions
    @IBAction func newCollection(sender: AnyObject) {
        for photo in pin.photos {
            photo.pin = nil
            sharedContext.deleteObject(photo)
            Flickr.Caches.imageCache.deleteImages(photo.id!)
            self.saveContext()
        }
        if pin.photos.isEmpty {
            Flickr.sharedInstance().getPathForImageBasedOnLocation(CLLocationCoordinate2DMake(pin.lat as Double, pin.long as Double)) { Results, error in
                if let error = error{
                    print(error)
                } else {
                    for imageData in Results! {
                        _ = Photo(path: imageData["imageURLString"]!, pin: self.pin, identifier: imageData["id"]!, context: self.sharedContext)
                    }
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.collectionView.reloadData()
                }
                self.saveContext()
            }
        }
    }
    
    // MARK: Collection View
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pin.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photo = pin.photos[indexPath.item]
        photo.pin = nil
        collectionView.deleteItemsAtIndexPaths([indexPath])
        Flickr.Caches.imageCache.deleteImages(photo.id!)
        sharedContext.deleteObject(photo)
        self.saveContext()
        
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let photo = pin.photos[indexPath.row]
        var cellImage = UIImage(named: "placeholderImage")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        cell.activityInd.startAnimating()
        
        // Configure the cell
        if photo.imagePath == nil || photo.imagePath == "" {
            cellImage = UIImage(named: "noimage")
            cell.imageView.image = cellImage
            cell.activityInd.stopAnimating()
        } else if photo.image != nil {
            cellImage = photo.image
            cell.imageView.image = cellImage
            cell.activityInd.stopAnimating()
        } else {
            Flickr.sharedInstance().taskForImage(photo.imagePath!) { imageData, error in
                if let error = error{
                    print(error)
                } else {
                    cellImage = UIImage(data: imageData!)
                    photo.image = cellImage
                    dispatch_async(dispatch_get_main_queue()){
                        cell.imageView.image = cellImage
                        cell.activityInd.stopAnimating()
                    }
                    
                }
                
            }
            cell.imageView.image = cellImage
        }
        return cell
    }
    
}
