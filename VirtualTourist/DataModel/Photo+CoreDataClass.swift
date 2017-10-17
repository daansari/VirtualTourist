//
//  Photo+CoreDataClass.swift
//  
//
//  Created by Danish Ahmed Ansari on 10/17/17.
//
//

import Foundation
import CoreData


public class Photo: NSManagedObject {
    convenience init(photo: PhotoModel, context: NSManagedObjectContext) {
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            if photo.id != nil {
                self.id = Int16(photo.id!)
            }
            if photo.heightM != nil {
                self.height = Double(photo.heightM!)
            }
            if photo.widthM != nil {
                self.width = Double(photo.widthM!)
            }
            if photo.owner != nil {
                self.owner = photo.owner
            }
            if photo.title != nil {
                self.title = photo.title
            }
            if photo.urlM != nil {
                self.url = photo.urlM
            }
            if photo.image != nil {
                self.image = photo.image
            }
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
