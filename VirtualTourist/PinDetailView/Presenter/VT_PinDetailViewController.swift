//
//  VT_PinDetailViewController.swift
//  VirtualTourist
//
//  Created by Danish Ahmed Ansari on 10/16/17.
//  Copyright © 2017 Deepturf. All rights reserved.
//

import UIKit
import MapKit

import MBProgressHUD

class VT_PinDetailViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userActionButton: UIButton!
    
    var selectedPin: Pin?
    var testArray = ["One", "Two", "Three"]
    var selectedPhotos: [Photo] = []
    var photos: [Photo] = []
    var hud: MBProgressHUD?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

