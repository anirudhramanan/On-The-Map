//
//  PostingMapViewController.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 01/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit
import MapKit

class PostingMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var enteredUrl: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var enteredLocation: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        createGeoLocationFromAddress(enteredLocation!, mapView: mapView)
    }
    
    @IBAction func submit(_ sender: Any) {
        indicatorView.isHidden = false
        NetworkClient.sharedInstance().postStudentLocation(completionHandler: {
            (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func createGeoLocationFromAddress(_ address: String, mapView: MKMapView) {
        
        let completion:CLGeocodeCompletionHandler = {(placemarks: [CLPlacemark]?, error: Error?) in
            if let placemarks = placemarks {
                for placemark in placemarks {
                    mapView.removeAnnotations(mapView.annotations)
                    // Instantiate annotation
                    let annotation = MKPointAnnotation()
                    // Annotation coordinate
                    annotation.coordinate = (placemark.location?.coordinate)!
                    annotation.subtitle = placemark.subLocality
                    mapView.addAnnotation(annotation)
                    mapView.showsPointsOfInterest = true
                    self.centerMapOnLocation(placemark.location!, mapView: mapView)
                }
            } else {
                
            }
        }
        
        CLGeocoder().geocodeAddressString(address, completionHandler: completion)
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        // once annotationView is added to the map, get the last one added unless it is the user's location:
        if let annotationView = views.last {
            // show callout programmatically:
            mapView.selectAnnotation(annotationView.annotation!, animated: false)
            // zoom to all annotations on the map:
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}