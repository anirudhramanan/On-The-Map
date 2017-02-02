//
//  StudentInformation.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 31/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation

struct StudentInformation {
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
    
    init?(jsonData: [String: AnyObject]) {
        guard let createdAt = jsonData["createdAt"] as? String,
            let firstName = jsonData["firstName"] as? String,
            let lastName = jsonData["lastName"] as? String,
            let latitude = jsonData["latitude"] as? Double,
            let longitude = jsonData["longitude"] as? Double,
            let mapString = jsonData["mapString"] as? String,
            let mediaURL = jsonData["mediaURL"] as? String,
            let objectId = jsonData["objectId"] as? String,
            let uniqueKey = jsonData["uniqueKey"] as? String,
            let updatedAt = jsonData["updatedAt"] as? String else{
                return nil
        }
        
        self.createdAt = createdAt
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.updatedAt = updatedAt
    }
    
    init () {}
}
