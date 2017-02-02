//
//  SessionStore.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 02/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation

struct SessionStore {
    static var sharedInstance = SessionStore()
    var session: Session!
    
    mutating func storeSession(_ jsonData: [String: Any]) -> Session{
        let session: Session = Session(jsonData: jsonData)!
        SessionStore.sharedInstance.session = session
        return SessionStore.sharedInstance.session!
    }
}
