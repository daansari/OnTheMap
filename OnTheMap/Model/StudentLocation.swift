//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/20/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import Foundation
import MapKit

struct StudentLocation {
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: String?
    var updatedAt: String?
    var coordinate: CLLocationCoordinate2D?
    
    init(dictionary: [String : Any]) {
        self.objectId = dictionary["objectId"] as? String
        self.uniqueKey = dictionary["uniqueKey"] as? String
        self.firstName = dictionary["firstName"] as? String
        self.lastName = dictionary["lastName"] as? String
        self.mapString = dictionary["mapString"] as? String
        self.mediaURL = dictionary["mediaURL"] as? String
        self.latitude = dictionary["latitude"] as? Double
        self.longitude = dictionary["longitude"] as? Double
        self.createdAt = dictionary["createdAt"] as? String
        self.updatedAt = dictionary["updatedAt"] as? String
        if let latitude = dictionary["latitude"] as? Double, let longitude = dictionary["longitude"] as? Double {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}
