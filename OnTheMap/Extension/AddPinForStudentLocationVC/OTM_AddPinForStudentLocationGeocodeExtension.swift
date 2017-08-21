//
//  OTM_AddPinForStudentLocationGeocodeExtension.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/21/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import Foundation
import MapKit
import TSMessages

typealias MapKitServiceResponse = (_ error: String?) -> Void
extension OTM_AddPinForStudentLocationViewController {
    func lookupCoordinatesFor(address: String, onCompletion: @escaping MapKitServiceResponse) -> Void {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = address
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                print("There was an error searching for: \(request.naturalLanguageQuery) error: \(error)")
                onCompletion(error?.localizedDescription)
                return
            }
            
            for item in response.mapItems {
                // Display the received items
                print("item - \(item)")
            }
            self.mapItems = response.mapItems
            onCompletion(nil)
        }
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
            mapView.userTrackingMode = .none
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        }
        else if (CLLocationManager.authorizationStatus() == .denied) || (CLLocationManager.authorizationStatus() == .restricted) {
            TSMessage.showNotification(in: self, title: "Location Services Disabled", subtitle: "Turn on Location Services for 'On The Map' => Settings > Privacy > Location Services > On the Map to continue using this app", type: .error)
        }
        else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
}
