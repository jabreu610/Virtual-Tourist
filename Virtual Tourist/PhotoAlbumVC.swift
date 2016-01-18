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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: Collection View
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        let photo = Photo.image
        
        // Configure the cell
        cell.imageView.image = photo
        
        return cell
    }

}
