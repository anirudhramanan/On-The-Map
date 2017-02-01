//
//  StudentInformation.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 31/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation

struct StudentInformation {
    var createdAt: String
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String
    
    init(jsonData: [String: AnyObject]) {
        self.createdAt = jsonData["createdAt"] as? String ?? ""
        self.firstName = jsonData["firstName"] as? String ?? ""
        self.lastName = jsonData["lastName"] as? String ?? ""
        self.latitude = jsonData["latitude"] as? Double ?? 0.0
        self.longitude = jsonData["longitude"] as? Double ?? 0.0
        self.mapString = jsonData["mapString"] as? String ?? ""
        self.mediaURL = jsonData["mediaURL"] as? String ?? ""
        self.objectId = jsonData["objectId"] as? String ?? ""
        self.uniqueKey = jsonData["uniqueKey"] as? String ?? ""
        self.updatedAt = jsonData["updatedAt"] as? String ?? ""
    }
}
