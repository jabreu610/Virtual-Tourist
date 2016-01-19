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

class PhotoAlbumVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var mapSnapshot: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // NARK: Properties
    var pin: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if pin.photos.isEmpty {
            Flickr.sharedInstance().searchForSingleImageBaseOnLocation(pin.coordinate) { imageData, error in
                if let error = error{
                    print(error)
                } else {
                    let photo = Photo(path: imageData)
                    print(imageData)
                    self.pin.photos.append(photo)
                    dispatch_async(dispatch_get_main_queue()){
                        self.collectionView.reloadData()
                    }
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
