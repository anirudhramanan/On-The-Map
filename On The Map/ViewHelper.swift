//
//  ViewHelper.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 02/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation
import UIKit

class ViewHelper {
 
    static func showLoadingView(message: String, showView: @escaping(_ alert: UIAlertController) -> Void) -> UIViewController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50,height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        showView(alert)
        return alert
    }
    
    static func showAlertForIncorrectState(message: String?, showView: @escaping(_ alert: UIAlertController) -> Void) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: nil))
        showView(alert)
    }
}
