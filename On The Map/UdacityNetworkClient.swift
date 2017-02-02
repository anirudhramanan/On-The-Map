//
//  UdacityNetworkClient.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 31/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation

extension NetworkClient {

    func authenticateUser(username: String, password: String, completionHandlerForAuth : @escaping(_ success: Bool, _ error: String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                //error
                DequeuThread.runOnMainThread({
                    completionHandlerForAuth(false, error?.localizedDescription)
                })
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForAuth(false, "Incorrect Credentials")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data!.count))
            let newData = data?.subdata(in: range)
            let json = try? JSONSerialization.jsonObject(with: newData!, options: [])
            let success = SessionStore.sharedInstance.storeSession(json as! [String: Any]).account?.registered
                
            if success != nil && success! {
                DequeuThread.runOnMainThread({
                    completionHandlerForAuth(success!, error?.localizedDescription)
                })
            } else{
                DequeuThread.runOnMainThread({
                    completionHandlerForAuth(false, "Something went wrong!")
                })
            }
        }
        task.resume()
    }
    
    func logoutUserSession(completionForLogout: @escaping(_ success: Bool, _ error: String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                DequeuThread.runOnMainThread({
                    completionForLogout(false, error?.localizedDescription)
                })
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                DequeuThread.runOnMainThread({
                    completionForLogout(false, "Something went wrong")
                })
                return
            }
            
            DequeuThread.runOnMainThread({
                completionForLogout(true, nil)
            })
        }
        task.resume()
    }
    
    func fetchUserData(completionHandlerForUserData: @escaping(_ data: [String: Any]) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/" + (SessionStore.sharedInstance.session.account?.key)!)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count))
            let newData = data?.subdata(in: range) /* subset response data! */
            let json = try? JSONSerialization.jsonObject(with: newData!, options: []) as! [String: Any]
            completionHandlerForUserData(json!)
        }
        task.resume()
    }
}
