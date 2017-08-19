//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/20/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import Foundation

class StudentLocation: NSObject {
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: Date?
    var updatedAt: Date?
    var acl: String?
    
    
    override init() {
        super.init()
    }
    
    func initStudentLocation(data: [String: AnyObject]!) {
        self.objectId = data["objectId"] as? String
        self.uniqueKey = data["uniqueKey"] as? String
        self.firstName = data["firstName"] as? String
        self.mapString = data["mapString"] as? String
        self.mediaURL = data["mediaURL"] as? String
        self.latitude = data["latitude"] as? Double
        self.longitude = data["longitude"] as? Double
        self.createdAt = data["createdAt"] as? Date
        self.updatedAt = data["updatedAt"] as? Date
        self.acl = data["acl"] as? String
    }
}
