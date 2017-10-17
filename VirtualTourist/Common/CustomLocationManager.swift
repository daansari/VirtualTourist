//
//  LocationManager.swift
//  VirtualTourist
//
//  Created by Danish Ahmed Ansari on 10/16/17.
//  Copyright © 2017 Deepturf. All rights reserved.
//

import Foundation
import MapKit

typealias CustomLocationManagerServiceResponse = (_ success: Bool, _ error: String?) -> Void

class CustomLocationManager {
    static let sharedInstance = CustomLocationManager()
    var locationManager: CLLocationManager?
    var mapItems: [MKMapItem] = []
    
    private init() {
        locationManager = CLLocationManager()
    }
    
    func checkLocationAuthorizationStatusWith(mapView: MKMapView, onCompletion: @escaping CustomLocationManagerServiceResponse) -> Void {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            onCompletion(true, nil)
        }
        else if (CLLocationManager.authorizationStatus() == .denied) || (CLLocationManager.authorizationStatus() == .restricted) {
            onCompletion(false, "Turn on Location Services for 'VirtualTourist' => Settings > Privacy > Location Services > VirtualTourist to continue using this app")
        }
        else {
            self.locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    func lookupCoordinatesFor(address: String, mapView: MKMapView, onCompletion: @escaping CustomLocationManagerServiceResponse) -> Void {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = address
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print("There was an error searching for: \(request.naturalLanguageQuery!) error: \((error?.localizedDescription)!)")
                }
                onCompletion(false, error?.localizedDescription)
                return
            }
            
            self.mapItems = response.mapItems
            onCompletion(true, nil)
        }
    }

}
