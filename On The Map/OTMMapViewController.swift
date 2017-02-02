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
    @IBOutlet weak var selectPin: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        loadAndAddAnnotations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        let alert = ViewHelper.showLoadingView(message: "Logging out...", showView: {
            alert in
            self.present(alert, animated: true, completion: nil)
        })
        
        NetworkClient.sharedInstance().logoutUserSession(completionForLogout: {
            (success, error) in
            alert.dismiss(animated: true, completion: nil)
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                ViewHelper.showAlertForIncorrectState(message: error, showView: {
                    alert in
                    self.present(alert, animated: true, completion: nil)
                })
            }
        })
    }
    
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
        if let mediaURL = view.annotation?.subtitle {
            guard let url = URL(string: (mediaURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!) else{
                return
            }
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}

extension OTMMapViewController {
    func configureMap() {
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.setCenter(self.mapView.region.center, animated: true)
    }
    
    func loadAndAddAnnotations() {
        StudentInformationStore.sharedInstance.studentInformation = []
        NetworkClient.sharedInstance().fetchStudentInformations(completionHandlerForSuccess: {
            (response) in
            for studentInfo in response {
                //we got a successful response with the data, let's add annotations on the map
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: studentInfo.latitude!, longitude: studentInfo.longitude!)
                annotation.title = studentInfo.firstName! + " " + studentInfo.lastName!
                annotation.subtitle = studentInfo.mediaURL
                self.mapView.addAnnotation(annotation)
            }
        }, completionHandlerForError: {error in
            //display errors in case of download failure
            ViewHelper.showAlertForIncorrectState(message: error, showView: {
                alert in
                self.present(alert, animated: true, completion: nil)
            })
        })
    }
}
