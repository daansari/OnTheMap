//
//  OTM_StudentsMapAuthorizationExtension.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/18/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import Foundation
import MapKit
import TSMessages

extension OTM_StudentsMapViewController {
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
            mapView.userTrackingMode = .none
//            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        }
        else if (CLLocationManager.authorizationStatus() == .denied) || (CLLocationManager.authorizationStatus() == .restricted) {
            TSMessage.showNotification(in: self, title: "Location Services Disabled", subtitle: "Turn on Location Services for 'On The Map' => Settings > Privacy > Location Services > On the Map to continue using this app", type: .error)
        }
        else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
}
