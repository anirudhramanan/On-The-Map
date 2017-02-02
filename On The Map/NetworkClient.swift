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
    
    func urlFromParameters(_ host: String, _ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = APIConstants.Udacity.Constants.ApiScheme
        components.host = host
        components.path = (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    func taskForParseAPI(_ method: String, _ headers :[String: String], _ body: Data?, taskCompletionHandler: @escaping(_ d: Data?,_ r: URLResponse?,_ e: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
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
    
    class func sharedInstance() -> NetworkClient {
        struct Singleton {
            static var sharedInstance = NetworkClient()
        }
        return Singleton.sharedInstance
    }
}
