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
    
    func postStudentLocation(_ enteredLocation: String? ,_ enteredUrl:String?,_ latitude: Double?,_ longitude: Double?,
                             _ completionHandler: @escaping(_ success: Bool, _ error: String?) -> Void) {
        fetchUserData(completionHandlerForUserData: {
            data in
            
            guard let results = data["user"] as? [String: Any], let firstName = results["first_name"] as? String, let lastName = results["last_name"] as? String
            else{
                return
            }
            var userData = StudentInformation()
            userData.longitude = longitude!
            userData.latitude = latitude!
            userData.mediaURL = enteredUrl!
            userData.mapString = enteredLocation!
            userData.firstName = firstName
            userData.lastName = lastName
            userData.uniqueKey = (SessionStore.sharedInstance.session.account?.key)!
            self.postLocationToParse(userData, completionHandler)
        })
    }
    
    private func postLocationToParse(_ user : StudentInformation, _ completionHandler: @escaping(_ success: Bool, _ error: String?) -> Void) {
        var headers:[String: String] = [:]
        headers["X-Parse-Application-Id"] = APIConstants.ParseKeys.APPLICATION_ID
        headers["X-Parse-REST-API-Key"] = APIConstants.ParseKeys.KEY
        headers["Content-Type"] = "application/json"
     
        let body = "{\"uniqueKey\": \"\(user.uniqueKey!)\", \"firstName\": \"\(user.firstName!)\", \"lastName\": \"\(user.lastName!)\", \"mapString\": \"\(user.mapString!)\",\"mediaURL\": \"\(user.mediaURL!)\", \"latitude\": \(user.latitude!), \"longitude\": \(user.longitude!)}".data(using: String.Encoding.utf8)
        
        self.taskForParseAPI("POST", headers, body!, taskCompletionHandler: {
            (data, response, error) in
            if error != nil { // Handle error…
                DispatchQueue.main.async {
                    completionHandler(false, error?.localizedDescription)
                }
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                DispatchQueue.main.async {
                    completionHandler(false, "There was a problem posting the location")
                }
                return
            }
            
            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
            guard jsonData?["objectId"] as? String != nil else {
                DispatchQueue.main.async {
                    completionHandler(false, "Something went wrong. Please try again.")
                }
                return
            }
            
            completionHandler(true, nil)
        })
    }
}
