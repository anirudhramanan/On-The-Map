//
//  OTMTableViewController.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 31/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import UIKit

class OTMTableViewController: UITableViewController {

    var studentInformation: [StudentInformation] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformation.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInfo", for: indexPath) as! OTMTableViewCell
        let studentInfo = studentInformation[indexPath.row]
        cell.personName.text = studentInfo.firstName! + " " + studentInfo.lastName!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInfo = studentInformation[indexPath.row]
        UIApplication.shared.open(NSURL(string: studentInfo.mediaURL!) as! URL, options: [:], completionHandler: nil)
    }
    
    private func loadData() {
        studentInformation = StudentInformationStore.sharedInstance.studentInformation
        studentInformation.sort(by : {
            $0.createdAt! > $1.createdAt!
        })
    }
}
