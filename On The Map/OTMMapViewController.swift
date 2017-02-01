//
//  OTMMapViewController.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 31/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit
import MapKit

class OTMMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.setCenter(self.mapView.region.center, animated: true)
        
        NetworkClient.sharedInstance().getStudentData(completionHandlerForData: {
            (response) in
            
            DispatchQueue.main.async {
                for studentInfo in response {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: studentInfo.latitude, longitude: studentInfo.longitude)
                    annotation.title = studentInfo.firstName + " " + studentInfo.lastName
                    annotation.subtitle = studentInfo.mediaURL
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    @IBAction func selectPin(_ sender: Any) {
    }
    @IBOutlet weak var selectPin: UIBarButtonItem!
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(NSURL(string:toOpen) as! URL, options: [:], completionHandler: nil)
            }
        }
    }
}
