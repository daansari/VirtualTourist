//
//  VT_MapViewController.swift
//  VirtualTourist
//
//  Created by Danish Ahmed Ansari on 10/16/17.
//  Copyright © 2017 Deepturf. All rights reserved.
//

import UIKit
import MapKit

class VT_MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deletePinsButton: UIButton!
    @IBOutlet weak var deletePinsButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    var pinsToDelete:[MKAnnotation]?
    var isEditMode: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
}
