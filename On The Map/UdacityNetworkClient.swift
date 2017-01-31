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
            if error != nil { // Handle error…
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count))
            let newData = data?.subdata(in: range)

            let json = try? JSONSerialization.jsonObject(with: newData!, options: [])
            let session: Session = Session(jsonData: json as! [String : Any])!
            
            let success = (session.account?.registered)!
                
            if success {
                completionHandlerForAuth(success, error?.localizedDescription)
            }
        }
        task.resume()
    }
}
