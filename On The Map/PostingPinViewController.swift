//
//  PostingPinViewController.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 01/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit
import MapKit

class PostingPinViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var locationText: UITextField!
    var loadingView: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationText.delegate = self
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func dismissLoadingScreen() {
        self.loadingView?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func locateOnMap(_ sender: Any) {
        let locationString = locationText.text
        
        if locationString == nil || locationString == "" {
            ViewHelper.showAlertForIncorrectState(message: "Please enter a location", showView: { alert in
                self.present(alert, animated: true, completion: nil)
            })
            return
        }
        
        loadingView = ViewHelper.showLoadingView(message: "Loading...", showView: { alert in
            self.present(alert, animated: true, completion: nil)
        })
        
        self.createGeoLocationFromAddress(locationString!, {
            (placemarks, error) in
            
            if error != nil {
                self.dismissLoadingScreen()
                ViewHelper.showAlertForIncorrectState(message: "Error parsing the given location", showView: { alert in
                    self.present(alert, animated: true, completion: nil)
                })
                return
            }
            
            self.dismissLoadingScreen()
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "PostingMapViewController") as! PostingMapViewController
            controller.enteredLocation = locationString!
            controller.placemarks = placemarks
            self.present(controller, animated: true, completion: nil)
        })
    }
    
    func createGeoLocationFromAddress(_ address: String,_ completeGeo: @escaping(_ placemarks: [CLPlacemark]?, _ error: Error?) -> Void) {
        let completion:CLGeocodeCompletionHandler = {(placemarks: [CLPlacemark]?, error: Error?) in
            if let placemarks = placemarks {
                DequeuThread.runOnMainThread {
                    completeGeo(placemarks, nil)
                }
            }  else if error != nil {
                DequeuThread.runOnMainThread {
                    completeGeo(nil, error)
                }
            }
        }
        
        CLGeocoder().geocodeAddressString(address, completionHandler: completion)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
