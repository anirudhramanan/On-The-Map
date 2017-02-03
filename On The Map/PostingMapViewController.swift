//
//  PostingMapViewController.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 01/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit
import MapKit

class PostingMapViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var enteredUrl: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var enteredLocation: String?
    var latitude: Double?
    var longitude: Double?
    var placemarks: [CLPlacemark]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        loadGeoLocation()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    private func hideIndicator(_ enable: Bool) {
        indicatorView.isHidden = enable
    }
    
    @IBAction func submit(_ sender: Any) {
        if NetworkConnectivityManager.isInternetAvailable() {
            hideIndicator(false)
            postStudentLocation()
        } else{
            ViewHelper.showAlertForIncorrectState(message: "No Internet Connectivity", showView: { alert in
                self.present(alert, animated: true, completion: nil)
            })
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension PostingMapViewController {
    func loadGeoLocation() {
        for placemark in placemarks {
            mapView.removeAnnotations(mapView.annotations)
            // Instantiate annotation
            let annotation = MKPointAnnotation()
            // Annotation coordinate
            annotation.coordinate = (placemark.location?.coordinate)!
            self.longitude = annotation.coordinate.longitude
            self.latitude = annotation.coordinate.latitude
            annotation.subtitle = placemark.subLocality
            mapView.addAnnotation(annotation)
            mapView.showsPointsOfInterest = true
            self.centerMapOnLocation(placemark.location!, mapView: mapView)
        }
    }
    
    func configureDelegates() {
        enteredUrl.delegate = self
        mapView.delegate = self
    }
    
    func postStudentLocation() {
        NetworkClient.sharedInstance().postStudentLocation(enteredLocation, enteredUrl.text, latitude, longitude, {
            (success, error) in
            if error != nil {
                ViewHelper.showAlertForIncorrectState(message: error, showView: { alert in
                    self.present(alert, animated: true, completion: nil)
                })
                return
            }
            
            if success {
                self.dismiss(animated: false, completion: nil)
                self.presentingViewController?.dismiss(animated: false, completion: nil)
            } else {
                ViewHelper.showAlertForIncorrectState(message: error, showView: { alert in
                    self.present(alert, animated: true, completion: nil)
                })
            }
        })
    }
}
