//
//  StudentInformationStore.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 31/01/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation

struct StudentInformationStore {
    var studentInformation: [StudentInformation] = []
    static var sharedInstance = StudentInformationStore()
    
    mutating func addStudentInformation(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        for result in results {
            guard let studentInfo = StudentInformation(jsonData: result) else {
                continue
            }
            studentInformation.append(studentInfo)
        }
        return studentInformation
    }
}
