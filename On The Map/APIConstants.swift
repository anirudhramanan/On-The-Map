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
    
    struct ParseKeys {
        static let APPLICATION_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
}
