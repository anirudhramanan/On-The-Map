//
//  NetworkClient.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 30/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation

class NetworkClient {
    
    var session = URLSession.shared
    var sessionID: String? = nil
  
    func taskForParseAPI(_ url: String, _ method: String, _ headers :[String: String], _ body: Data?, taskCompletionHandler: @escaping(_ d: Data?,_ r: URLResponse?,_ e: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = method
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        if body != nil {
            request.httpBody = body!
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            taskCompletionHandler(data, response, error as NSError?)
        }
        task.resume()
    }
    
    func taskForUdacityAPI(_ url: String, _ method: String, _ headers :[String: String]? , _ body: Data?, _ cookie: [String: String]?,
                           taskCompletionHandler: @escaping(_ d: Data?,_ r: URLResponse?,_ e: NSError?) -> Void) {
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: URL(string: url)!)
      
        request.httpMethod = method

        if let mHeaders = headers {
            for (key, value) in mHeaders {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let cookies = cookie {
            for (key, value) in cookies {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if body != nil {
            request.httpBody = body!
        }
    
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            taskCompletionHandler(data, response, error as NSError?)
        }
        task.resume()
    }
    
    class func sharedInstance() -> NetworkClient {
        struct Singleton {
            static var sharedInstance = NetworkClient()
        }
        return Singleton.sharedInstance
    }
}
