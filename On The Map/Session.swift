//
//  Session.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 31/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation

struct Session {
    
    var account:Account?
    var session: SessionInfo?
    
    init?(jsonData: [String: Any]){
        guard let account = jsonData["account"] as? [String: Any],
            let registered = account["registered"] as? Bool,
            let key = account["key"] as? String,
            let session = jsonData["session"] as? [String: Any],
            let sessionId = session["id"] as? String,
            let expiration = session["expiration"] as? String
            else{
                return nil
        }
        
        self.account = Account(registered: registered, key: key)
        self.session = SessionInfo(id: sessionId, expiration: expiration)
    }
    
    struct Account{
        var registered:Bool
        var key: String
        
        init(registered:Bool, key:String) {
            self.registered = registered
            self.key = key
        }
    }
    
    struct SessionInfo {
        var id: String
        var expiration: String
        
        init(id: String, expiration: String) {
            self.id = id
            self.expiration = expiration
        }
    }
}
