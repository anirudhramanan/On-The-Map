//
//  OTMMapViewController.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 31/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit
import MapKit

class OTMMapViewController: UIViewController {
    
    @IBOutlet weak var logoutUser: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        
        NetworkClient.sharedInstance().getStudentData(completionHandlerForData: {
            (response) in
            
            DispatchQueue.main.async {
                for studentInfo in response {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: studentInfo.latitude, longitude: studentInfo.longitude)
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutSession(_ sender: Any) {
        
    }
}
