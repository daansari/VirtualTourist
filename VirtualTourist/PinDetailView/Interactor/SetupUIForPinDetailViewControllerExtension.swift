//
//  SetupUIForPinDetailViewControllerExtension.swift
//  VirtualTourist
//
//  Created by Danish Ahmed Ansari on 10/17/17.
//  Copyright © 2017 Deepturf. All rights reserved.
//

import Foundation
import MapKit

private let reuseIdentifier = "PinDetail"

extension VT_PinDetailViewController {
    func setupUI() {
//        setupCollectionView()
        setupMapView()
        getPhotos()
    }
    
    func setupMapView() {
        mapView.isUserInteractionEnabled = false
        let pointLocation = CLLocationCoordinate2D(latitude: (selectedPin?.latitude)!, longitude: (selectedPin?.longitude)!)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: pointLocation, span: span)
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pointLocation
        mapView.addAnnotation(annotation)
    }
    
    func setupCollectionView() {
        // Register cell classes
        self.collectionView!.register(VT_PinDetailCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
}
