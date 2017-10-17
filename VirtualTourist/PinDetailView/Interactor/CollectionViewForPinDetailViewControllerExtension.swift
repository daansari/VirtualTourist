//
//  CollectionViewForPinDetailViewControllerExtension.swift
//  VirtualTourist
//
//  Created by Danish Ahmed Ansari on 10/17/17.
//  Copyright © 2017 Deepturf. All rights reserved.
//

import Foundation
import UIKit

import ChameleonFramework

private let reuseIdentifier = "PinDetail"

extension VT_PinDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }
    
    func getDataFromUrl(url:String, completion: @escaping ((_ data: NSData?) -> Void)) {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            completion(NSData(data: data!))
            }.resume()
    }
    
    func downloadImage(url:String, photo: Photo, indexPath: IndexPath){
        getDataFromUrl(url: url) { data in
            DispatchQueue.main.async() {
                if let image = UIImage(data: data! as Data){
                    let cell = self.collectionView.cellForItem(at: indexPath) as! VT_PinDetailCollectionViewCell
                    cell.flickrImageView.image = image
                    photo.image = data
                    do {
                        try CoreDataStack.sharedInstance.saveContext()
                    }
                    catch {
                        print("error saving")
                    }

                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VT_PinDetailCollectionViewCell
        
        // Configure the cell
        cell.backgroundColor = UIColor.flatGray
        
        let photo = photos[indexPath.row]
                
        if photo.image == nil {
            cell.flickrImageView.backgroundColor = UIColor.flatGray
            cell.flickrImageView.image = nil
            guard let imageUrlString = photo.url else {
                print("Cannot find keys - \(Constants.FlickrResponseKeys.MediumURL) in \(photo)")
                return cell
            }
            downloadImage(url: imageUrlString, photo: photo, indexPath: indexPath)
        }
        else {
            cell.flickrImageView.image = UIImage(data: photo.image! as Data)
        }
        
        return cell
    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    
     // Uncomment this method to specify if the specified item should be selected
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! VT_PinDetailCollectionViewCell
        
        let photo = photos[indexPath.row]
        
        if let index = selectedPhotos.index(of: photo) {
            selectedPhotos.remove(at: index)
            cell.alpha = 1
        }
        else {
            selectedPhotos.append(photo)
            cell.alpha = 0.5
        }
        
        if selectedPhotos.count == 0 {
            userActionButton.setTitle("New Collection", for: .normal)
        }
        else {
            userActionButton.setTitle("Remove Selected Pictures", for: .normal)
        }
        
//        if result == nil {
//            selectedPhotos.append(photo)
//            cell.alpha = 0.5
//        }
//        else {
//            let index = selectedPhotos.index(of: photo)
//            selectedPhotos.remove(at: index!)
//            cell.alpha = 1
//        }
        
//        if cell.alpha == 0.5 {
//            cell.alpha = 1
//        }
//        else {
//            cell.alpha = 0.5
//        }
    }
}

extension VT_PinDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow = 3
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        return CGSize(width: size, height: size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
}
