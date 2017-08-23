//
//  StudentLocationSingleton.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/23/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import Foundation

class StudentLocationSingleton {
    static let sharedInstance = StudentLocationSingleton()
    var studentLocations: [StudentLocation]! = []
    
    private init() {
    }
    
    
}
