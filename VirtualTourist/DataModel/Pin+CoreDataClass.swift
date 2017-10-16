//
//  Pin+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Danish Ahmed Ansari on 10/16/17.
//  Copyright © 2017 Deepturf. All rights reserved.
//
//

import Foundation
import CoreData


public class Pin: NSManagedObject {
    convenience init(latitude: Double = 0.0, longitude: Double = 0.0, context: NSManagedObjectContext) {
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
            self.init(entity: ent, insertInto: context)
            self.latitude = latitude
            self.longitude = longitude
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
