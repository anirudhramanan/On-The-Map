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
    
    @IBAction func selectPin(_ sender: Any) {
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        let alert = showLogoutOverlay()
        NetworkClient.sharedInstance().logoutUserSession(completionForLogout: {
            (success, error) in
            alert.dismiss(animated: true, completion: nil)
            if success {
                self.dismiss(animated: true, completion: nil)
            } else{
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.actionSheet)
                alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
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
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(NSURL(string:toOpen) as! URL, options: [:], completionHandler: nil)
            }
        }
    }
}

extension OTMMapViewController {
    func configureMap() {
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.setCenter(self.mapView.region.center, animated: true)
    }
    
    func loadAndAddAnnotations(){
        NetworkClient.sharedInstance().fetchStudentInformations(completionHandlerForSuccess: {
            (response) in
            for studentInfo in response {
                //we got a successful response with the data, let's add annotations on the map
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: studentInfo.latitude, longitude: studentInfo.longitude)
                annotation.title = studentInfo.firstName + " " + studentInfo.lastName
                annotation.subtitle = studentInfo.mediaURL
                self.mapView.addAnnotation(annotation)
            }
        }, completionHandlerForError: {error in
            //display errors in case of download failure
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func showLogoutOverlay() -> UIViewController {
        let alert = UIAlertController(title: nil, message: "Logging out...", preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50,height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        return alert
    }
}
