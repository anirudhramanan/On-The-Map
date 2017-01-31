//
//  APIConstants.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 30/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation

struct APIConstants {
    
    struct Udacity {
        
        struct Constants {
            static let host = "www.udacity.com"
            static let ApiScheme = "https"
        }
        
        struct Method {
            static let authenticateSession = "/api/session"
        }
        
        struct ParameterKeys {
            static let Username = "username"
            static let Password = "password"
        }
    }
}
