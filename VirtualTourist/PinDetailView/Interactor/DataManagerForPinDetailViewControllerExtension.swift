//
//  DataManagerForPinDetailViewControllerExtension.swift
//  VirtualTourist
//
//  Created by Danish Ahmed Ansari on 10/17/17.
//  Copyright © 2017 Deepturf. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension VT_PinDetailViewController {
    
    func getExistingPhotosFor(pin: Pin) -> [NSFetchRequestResult]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        let predicate = NSPredicate(format: "pin = %@", argumentArray: [pin])
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "url", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            return fetchedResultsController.fetchedObjects
        }
        catch {
            print("fc error")
            return nil
        }
    }
    
    func deleteExistingPhotosFor(pin: Pin) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        let predicate = NSPredicate(format: "pin = %@", argumentArray: [pin])
        fetchRequest.predicate = predicate
        
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try CoreDataStack.sharedInstance.context.execute(request)
        } catch {
            print("error")
        }
    }
    
    func getPhotos() {
        if let existingPhotos = getExistingPhotosFor(pin: selectedPin!) {
            if existingPhotos.count > 0 {
                for object in existingPhotos {
                    let photo = object as! Photo
                    photos.append(photo)
                }
            }
            else {
                getFreshPhotos()
            }
        }
        else {
            getFreshPhotos()
        }
    }
    
    func getFreshPhotos() {
        deleteExistingPhotosFor(pin: selectedPin!)
        
        let randomPage = Int(arc4random_uniform(UInt32(FlickrManager.sharedInstance.pages)))
        
        let methodParameters: [String: AnyObject] = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod as AnyObject,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey as AnyObject,
            Constants.FlickrParameterKeys.BoundingBox: bboxString() as AnyObject,
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch as AnyObject,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL as AnyObject,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat as AnyObject,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback as AnyObject,
            Constants.FlickrParameterKeys.Page: randomPage as AnyObject,
            Constants.FlickrParameterKeys.PerPage: Constants.FlickrParameterValues.PerPage as AnyObject
        ]
                
        FlickrManager.sharedInstance.getImagesFromFlickrBySearch(pin: selectedPin!, methodParameters, with: randomPage) { (success, error, photosArray) in
            self.photos = photosArray
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func bboxString() -> String {
        if let latValue = selectedPin?.latitude, let longValue = selectedPin?.longitude {
            let minLat = max(latValue - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
            let maxLat = min(latValue + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
            
            let minLong = max(longValue - Constants.Flickr.SearchBBoxHalfWidth , Constants.Flickr.SearchLonRange.0)
            let maxLong = min(longValue + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
            
            return "\(minLong),\(minLat),\(maxLong),\(maxLat)"
        }
        else {
            return "0,0,0,0"
        }
    }
}
