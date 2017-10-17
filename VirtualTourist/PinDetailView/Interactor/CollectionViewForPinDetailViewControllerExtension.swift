//
//  CollectionViewForPinDetailViewControllerExtension.swift
//  VirtualTourist
//
//  Created by Danish Ahmed Ansari on 10/17/17.
//  Copyright © 2017 Deepturf. All rights reserved.
//

import Foundation
import UIKit

import FontAwesomeKit
import ChameleonFramework
import SDWebImage

private let reuseIdentifier = "PinDetail"

extension VT_PinDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VT_PinDetailCollectionViewCell
        
        // Configure the cell
        cell.backgroundColor = UIColor.flatGray
        
        let placeholderIcon = FAKFontAwesome.fileImageOIcon(withSize: 30)
        placeholderIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.flatWhite)
        let placeholderIconImage = placeholderIcon?.image(with: CGSize(width: cell.flickrImageView.frame.size.width, height: cell.flickrImageView.frame.size.height))
        
        
        let photo = photos[indexPath.row]
                
        if photo.image == nil {
            cell.flickrImageView.backgroundColor = UIColor.flatGray
            guard let imageUrlString = photo.url else {
                print("Cannot find keys - \(Constants.FlickrResponseKeys.MediumURL) in \(photo)")
                return cell
            }
            
            let url = URL(string: imageUrlString)
            cell.flickrImageView.sd_setImage(with:  url, placeholderImage: placeholderIconImage, options: SDWebImageOptions.refreshCached, progress: { (receivedSize, expectedSize, targetURL) in
                
            }, completed: { (image, error, cacheType, url) in
                let data = UIImageJPEGRepresentation(image!, 1) as NSData?
                photo.image = data
                do {
                    try CoreDataStack.sharedInstance.saveContext()
                }
                catch {
                    print("error saving")
                }
            })
//            downloadImage(url: imageUrlString, photo: photo, indexPath: indexPath)
        }
        else {
            cell.flickrImageView.image = UIImage(data: photo.image! as Data)
        }
        
        return cell
    }
    
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
