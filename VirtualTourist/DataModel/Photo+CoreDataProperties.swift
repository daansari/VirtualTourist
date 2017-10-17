//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Danish Ahmed Ansari on 10/17/17.
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
    @NSManaged public var image: NSData?
    @NSManaged public var owner: String?
    @NSManaged public var title: String?
    @NSManaged public var width: Double
    @NSManaged public var url: String?
    @NSManaged public var pin: Pin?

}
