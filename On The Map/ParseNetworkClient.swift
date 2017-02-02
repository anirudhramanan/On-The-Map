//
//  ParseNetworkClient.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 31/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation

extension NetworkClient {
    
    func fetchStudentInformations(completionHandlerForSuccess : @escaping(_ listofStudent: [StudentInformation]) -> Void
        , completionHandlerForError: @escaping(_ error: String?) -> Void) {
        
        var headers:[String: String] = [:]
        headers["X-Parse-Application-Id"] = APIConstants.ParseKeys.APPLICATION_ID
        headers["X-Parse-REST-API-Key"] = APIConstants.ParseKeys.KEY

        taskForParseAPI("GET", headers, nil, taskCompletionHandler: {
            (data, response, error) in
            if error != nil { // Handle error...
                DispatchQueue.main.async {
                    completionHandlerForError(error?.localizedDescription)
                }
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                DispatchQueue.main.async {
                    completionHandlerForError("There was a problem downloading the student Information")
                }
                return
            }
            
            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
            guard let json = jsonData?["results"] as? [[String: AnyObject]] else {
                DispatchQueue.main.async {
                    completionHandlerForError("Something went wrong. Please try again.")
                }
                return
            }
            
            let studentInformations = StudentInformationStore.sharedInstance.addStudentInformation(json)
            
            DispatchQueue.main.async {
                completionHandlerForSuccess(studentInformations)
            }
        })
    }
    
    func postStudentLocation(completionHandler: @escaping(_ success: Bool, _ error: String?) -> Void) {
        
        var headers:[String: String] = [:]
        headers["X-Parse-Application-Id"] = APIConstants.ParseKeys.APPLICATION_ID
        headers["X-Parse-REST-API-Key"] = APIConstants.ParseKeys.KEY
        headers["Content-Type"] = "application/json"
        
        let httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)
        
        taskForParseAPI("POST", headers, httpBody, taskCompletionHandler: {
            (data, response, error) in
            if error != nil { // Handle error…
                return
            }
            DispatchQueue.main.async {
                completionHandler(true, nil)
            }
        })
    }
}
