//
//  Photo+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Danish Ahmed Ansari on 10/16/17.
//  Copyright © 2017 Deepturf. All rights reserved.
//
//

import Foundation
import CoreData


public class Photo: NSManagedObject {
    convenience init(data: [String: Any], context: NSManagedObjectContext) {
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            self.id = Int16(data["id"] as! Int)
            self.height = data["height"] as! Double
            self.width = data["width"] as! Double
            self.owner = data["owner"] as? String
            self.title = data["title"] as? String
            self.image_url = data["image_url"] as? String
            self.image_path = data["image_path"] as? String
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
