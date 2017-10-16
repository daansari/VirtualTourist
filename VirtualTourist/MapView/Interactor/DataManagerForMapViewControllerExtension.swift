//
//  DataManager.swift
//  VirtualTourist
//
//  Created by Danish Ahmed Ansari on 10/16/17.
//  Copyright © 2017 Deepturf. All rights reserved.
//

import Foundation
import MapKit
import CoreData

extension VT_MapViewController {
    func savePin(annotation: MKAnnotation) {
        let pin = Pin(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude, context: CoreDataStack.sharedInstance.context)
        CoreDataStack.sharedInstance.save()
        print("pin to save")
        print("pin.latitude - \(pin.latitude)")
        print("pin.longitude - \(pin.longitude)")
    }
    
    func deletePins(annotations: [MKAnnotation]?) {
        if let pins = pinsToDelete {
            if pins.count > 0 {
                mapView.removeAnnotations(pins)
                var latitudes: [Double] = []
                var longitudes: [Double] = []
                for pin in pins {
                    print("pin to delete")
                    print("pin.latitude - \(pin.coordinate.latitude)")
                    print("pin.longitude - \(pin.coordinate.longitude)")
                    latitudes.append(pin.coordinate.latitude)
                    longitudes.append(pin.coordinate.longitude)
                }
                
                if latitudes.count > 0 && longitudes.count > 0 {
                    let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
                    let predicate = NSPredicate(format: "latitude IN %@ AND longitude IN %@", latitudes, longitudes)
                    fr.predicate = predicate
                    
                    let request = NSBatchDeleteRequest(fetchRequest: fr)
                    
                    do {
                        try CoreDataStack.sharedInstance.context.execute(request)
                    } catch {
                        print("error")
                    }
                }
            }
        }
        
    }
}
