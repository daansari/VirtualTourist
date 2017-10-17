//
//  SetupUIForMapViewControllerExtension.swift
//  VirtualTourist
//
//  Created by Danish Ahmed Ansari on 10/16/17.
//  Copyright © 2017 Deepturf. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import TSMessages

extension VT_MapViewController {
    func setupUI() {
        showHideDeletePinButton(show: false)
        setupMapViewUI()
        setupExistingMapPins()
        setupLongTapGestureRecognizer()
    }
    
    func showHideDeletePinButton(show: Bool) {
        UIView.animate(withDuration: 0.1) {
            if show == true {
                self.deletePinsButtonHeightConstraint.constant = 50
            }
            else {
                self.deletePinsButtonHeightConstraint.constant = 0
            }
            self.view.setNeedsLayout()
        }
    }
    
    func setupMapViewUI() {
//        pins = []
        pinsToDelete = []
        CustomLocationManager.sharedInstance.checkLocationAuthorizationStatusWith(mapView: mapView) { (success, error) in
            if success == true {
            }
            else {
               TSMessage.showNotification(in: self, title: "Location Services Error", subtitle: error, type: .error)
            }
        }
    }
    
    func setupExistingMapPins() {
        let result = getExistingPins()
        
        if let objects = result {
            for object in objects {
                let pin = object as! Pin                
                let coordinate = CLLocationCoordinate2DMake(pin.latitude, pin.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    @IBAction func didTapEditButton(_ sender: Any) {
        if isEditMode == false {
            isEditMode = true
            showHideDeletePinButton(show: isEditMode)
        }
        else {
            isEditMode = false
            showHideDeletePinButton(show: isEditMode)
            deletePins(annotations: pinsToDelete)
        }
    }
    
    
    @IBAction func didTapDeletePinsButton(_ sender: Any) {
    }
}

extension VT_MapViewController: UIGestureRecognizerDelegate {
    func setupLongTapGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(VT_MapViewController.handleTap(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 0.5
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
            
            // Add annotation:
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
            savePin(annotation: annotation)
        case .possible: break
            
        case .changed: break
            
        case .ended: break
            
        case .cancelled: break
            
        case .failed: break
            
        }
        
//        let pointLocation = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
//        let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
//        let region = MKCoordinateRegion(center: pointLocation, span: span)
//        self.mapView.setRegion(region, animated: true)
    }
}

extension VT_MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if Constants.ModeKey.Environment == Constants.ModeValue.Development {
            print("did select annotation view")
            print("view.annotation?.coordinate.latitude - \((view.annotation?.coordinate.latitude)!)")
            print("view.annotation?.coordinate.longitude - \((view.annotation?.coordinate.longitude)!)")
        }
        
        if isEditMode {
            // Add to remove pins array
            if let index = self.pinsToDelete?.index(where: { (annotation: MKAnnotation) -> Bool in
                if (annotation.coordinate.latitude == view.annotation?.coordinate.latitude) && (annotation.coordinate.longitude == view.annotation?.coordinate.longitude) {
                    return true
                }
                return false
            }) {
                pinsToDelete!.remove(at: index)
            }
            else {
                pinsToDelete!.append(view.annotation!)
            }
        }
        else {
            // Open Pin Detail View
            let pin = getPinWith(annotation: view.annotation!)
            
            let navigationController = self.storyboard!.instantiateViewController(withIdentifier: "PinDetailNavController") as! UINavigationController
            
            let pinDetailViewController = navigationController.viewControllers.first as! VT_PinDetailViewController
            pinDetailViewController.selectedPin = pin
        
            self.navigationController?.pushViewController(pinDetailViewController, animated: true)
//            self.present(navigationController, animated: true, completion: nil)
        }
    }
}
