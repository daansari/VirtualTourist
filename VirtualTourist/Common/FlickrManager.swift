//
//  FlickrManager.swift
//  VirtualTourist
//
//  Created by Danish Ahmed Ansari on 10/17/17.
//  Copyright © 2017 Deepturf. All rights reserved.
//

import Foundation
import UIKit

typealias FlickrManagerServiceResponseForPhotoFetch = (_ success: Bool, _ error: String?, _ photos: [Photo]) -> Void

class FlickrManager {
    static let sharedInstance = FlickrManager()
    var pages = 0
    var randomPage = 0
    var photosFromFlickr: [PhotoModel] = []
    var photos: [Photo] = []
    
    func getImagesFromFlickrBySearch(pin: Pin, _ methodParameters: [String: AnyObject], with pageNumber: Int, onCompletion: @escaping FlickrManagerServiceResponseForPhotoFetch) {        
        photosFromFlickr = []
        photos = []
        
        randomPage = pageNumber
    
        var methodParameters = methodParameters
        let url = flickrURLFromParameters(methodParameters)
        
        print(url)
        
        // TODO: Make request to Flickr!
        let session = URLSession.shared
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func displayError(error: String) {
                print("error: \(error)")
                print("url at the time of error: \(url)")
                onCompletion(false, error, self.photos)
            }
            
            /* GUARD: Was there any error returned? */
            guard (error == nil) else {
                displayError(error: "There was an error in your request - \((error?.localizedDescription)!)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError(error: "No data was returned by the request!")
                return
            }
            
            /* GUARD: Did we get successful 2XX reponse */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError(error: "Your request sent a status code other than 2XX!")
                return
            }
            
            do {
                let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                print(parsedResult)
                
                /* GUARD: Did we get successful OK reponse */
                guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                    displayError(error: "Flickr API returned an error. See error code and message in \(parsedResult)")
                    return
                }
                
                /* GUARD: Was there any photos and photo returned? */
                guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos], let photoArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]], let pages = photosDictionary[Constants.FlickrResponseKeys.Pages] as? Int else {
                    displayError(error: "Cannot find keys - \(Constants.FlickrResponseKeys.Photos), \(Constants.FlickrResponseKeys.Photo) and \(Constants.FlickrResponseKeys.Pages) in \(parsedResult)")
                    return
                }
                
                self.pages = pages
                
                print("number of pages for photo - \(self.pages)")
                print("randomPageIndex - \(self.randomPage)")
                print("photosDictionary - \(photosDictionary)")
                print("\nphotoArray - \(photoArray)")
                
                for photo in photoArray {
                    let photoObjc = PhotoModel.init()
                    photoObjc.initPhoto(data: photo)
                    self.photosFromFlickr.append(photoObjc)
                }
                
                print("\nphotosFromFlickr - \(self.photosFromFlickr)")
                
                DispatchQueue.main.async {
                    for photo in self.photosFromFlickr {
                        let savedPhoto = Photo(photo: photo, context: CoreDataStack.sharedInstance.context)
                        savedPhoto.pin = pin
                        self.photos.append(savedPhoto)
                    }
                }
                
                
            }
            catch {
                displayError(error: "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    try CoreDataStack.sharedInstance.saveContext()
                }
                catch {
                    print("error saving")
                }
                onCompletion(true, nil, self.photos)
            }
        }
        
        task.resume()
    }
    
    // MARK: Helper for Creating a URL from Parameters
    
    private func flickrURLFromParameters(_ parameters: [String: AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}
