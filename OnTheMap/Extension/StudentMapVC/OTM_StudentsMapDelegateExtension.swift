//
//  OTM_StudentsMapDelegateExtension.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/21/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import Foundation
import MapKit
import TSMessages

extension OTM_StudentsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseIdentifier = "StudentUserLocationAnnotation"
        var view: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let mediaURL = view.annotation?.subtitle {
            let url = URL(string: mediaURL!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
        else {
            TSMessage.showNotification(in: self, title: "Error", subtitle: "MediaURL not found", type: .error)
        }
    }
}
