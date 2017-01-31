//
//  ParseNetworkClient.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 31/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation

extension NetworkClient {
    
    func getStudentData( completionHandlerForData : @escaping(_ listofStudent: [StudentInformation]) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
            guard let json = jsonData?["results"] as? [[String: AnyObject]] else{
                return
            }
            
            let studentInformations = StudentInformationStore.sharedInstance.addStudentInformation(json)
            completionHandlerForData(studentInformations)
        }
        task.resume()
    }
}
