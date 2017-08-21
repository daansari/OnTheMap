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
        if let annotation = view.annotation {
            if let mediaURL = annotation.subtitle as? String {
                if canOpenURL(string: mediaURL) {
                    if let url = URL(string: mediaURL) {
                        let alert = UIAlertController(title: "Open in Safari", message: "\(mediaURL)?", preferredStyle: .alert)
                        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        })
                        alert.addAction(yesAction)
                        
                        let noAction = UIAlertAction(title: "No", style: .destructive, handler: { (action) in
                        })
                        alert.addAction(noAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        TSMessage.showNotification(in: self, title: "Error", subtitle: "MediaURL not valid for opening in Safari: \(mediaURL)", type: .error)
                    }
                }
                else {
                    TSMessage.showNotification(in: self, title: "Error", subtitle: "MediaURL not valid for opening in Safari: \(mediaURL)", type: .error)
                }
            }
            else {
                TSMessage.showNotification(in: self, title: "Error", subtitle: "MediaURL not found", type: .error)
            }
        }
        else {
            TSMessage.showNotification(in: self, title: "Error", subtitle: "Annotation not found", type: .error)
        }
    }
    
    func canOpenURL(string: String?) -> Bool {
        guard let urlString = string?.trimmingCharacters(in: .whitespaces) else {return false}
        guard let url = URL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url) {return false}
        
        //
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: urlString)
    }
}
