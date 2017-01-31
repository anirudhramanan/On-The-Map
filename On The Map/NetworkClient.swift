//
//  NetworkClient.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 30/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation

class NetworkClient : NSObject {
    
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
    
    class func sharedInstance() -> NetworkClient {
        struct Singleton {
            static var sharedInstance = NetworkClient()
        }
        return Singleton.sharedInstance
    }
}
