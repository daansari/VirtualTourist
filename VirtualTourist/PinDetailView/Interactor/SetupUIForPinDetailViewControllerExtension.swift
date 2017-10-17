//
//  SetupUIForPinDetailViewControllerExtension.swift
//  VirtualTourist
//
//  Created by Danish Ahmed Ansari on 10/17/17.
//  Copyright © 2017 Deepturf. All rights reserved.
//

import Foundation
import MapKit

import MBProgressHUD

private let reuseIdentifier = "PinDetail"

extension VT_PinDetailViewController {
    func setupUI() {
        setupProgressHUD()
        setupMapView()
        getPhotos()
    }
    
    func setupMapView() {
        mapView.isUserInteractionEnabled = false
        let pointLocation = CLLocationCoordinate2D(latitude: (selectedPin?.latitude)!, longitude: (selectedPin?.longitude)!)
        let span = MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 1.5)
        let region = MKCoordinateRegion(center: pointLocation, span: span)
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pointLocation
        mapView.addAnnotation(annotation)
    }
    
    func setupProgressHUD() {
        hud = MBProgressHUD.init(view: self.view)
        hud?.animationType = .zoom
        hud?.mode = .indeterminate
        hud?.backgroundColor = UIColor.flatBlack.withAlphaComponent(0.75)
        self.view.addSubview(hud!)
        
        hud?.label.text = "Fetching Photos..."
        hud?.show(animated: true)
    }

    @IBAction func didTapUserActionButton(_ sender: Any) {
        hud?.label.text = "Fetching Photos..."
        hud?.show(animated: true)
        if selectedPhotos.count == 0 {
            getFreshPhotos()
        }
        else {
            // Delete Selected Pictures
            deleteSelectedPhotos()
            getPhotos()
            userActionButton.setTitle("New Collection", for: .normal)
            collectionView.reloadData()
        }
    }
    
}
