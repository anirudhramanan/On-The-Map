//
//  OTMTableViewController.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 31/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit

class OTMTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformationStore.sharedInstance.studentInformation.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInfo", for: indexPath) as! OTMTableViewCell
        let studentInfo = StudentInformationStore.sharedInstance.studentInformation[indexPath.row]
        cell.personName.text = studentInfo.firstName! + " " + studentInfo.lastName!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let studentInfo = StudentInformationStore.sharedInstance.studentInformation[indexPath.row]
        if let mediaURL = studentInfo.mediaURL {
            guard let url = URL(string: (mediaURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!) else{
                return
            }	
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}
