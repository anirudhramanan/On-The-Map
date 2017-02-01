//
//  DequeuThread.swift
//  On The Map
//
//  Created by Anirudh Ramanan on 01/02/17.
//  Copyright © 2017 Anirudh Ramanan. All rights reserved.
//

import Foundation

class DequeuThread {
    
    static func runOnMainThread(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
