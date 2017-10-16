//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Danish Ahmed Ansari on 10/16/17.
//  Copyright © 2017 Deepturf. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var height: Double
    @NSManaged public var id: Int16
    @NSManaged public var owner: String?
    @NSManaged public var title: String?
    @NSManaged public var image_url: String?
    @NSManaged public var width: Double
    @NSManaged public var image_path: String?
    @NSManaged public var pin: Pin?

}
