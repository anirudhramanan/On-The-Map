//
//  PostingPinViewController.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 01/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit
import MapKit

class PostingPinViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var locationText: UITextField!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func locateOnMap(_ sender: Any) {
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "openMapPin":
            guard let destVC = segue.destination as? PostingMapViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            destVC.enteredLocation = locationText.text
            break
        default:
            break
        }
    }
}
