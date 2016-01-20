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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.scrollEnabled = false
        mapView.zoomEnabled = false
        mapView.rotateEnabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        mapView.region = MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        mapView.addAnnotation(pin)
        
        if pin.photos.isEmpty {
            Flickr.sharedInstance().searchForSingleImageBaseOnLocation(pin.coordinate) { Results, error in
                if let error = error{
                    print(error)
                } else {
                    for imageData in Results! {
                        let photo = Photo(path: imageData)
                        print(imageData)
                        self.pin.photos.append(photo)
                    }
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
    
    // MARK: Collection View
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pin.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let photo = pin.photos[indexPath.row]
        var cellImage = UIImage(named: "placeholderImage")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        // Configure the cell
        
        if photo.image != nil {
            cellImage = photo.image
        } else {
            if let imageData = NSData(contentsOfURL: NSURL(string: photo.imagePath!)!){
                let image = UIImage(data: imageData)
                photo.image = image
                dispatch_async(dispatch_get_main_queue()){
                    cell.imageView.image = image
                }
            }
        }
        
        cell.imageView.image = cellImage
        
        return cell
    }

}
