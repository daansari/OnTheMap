//
//  OTM_StudentsMapUserInterfaceExtension.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/21/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import Foundation
import MapKit
import TSMessages

extension OTM_StudentsMapViewController {
    // MARK: Manage Student Location Data
    func getStudentLocations() {
        let parameters = [
            Constants.ParseParameterKeys.Limit: 100,
            Constants.ParseParameterKeys.Order: "-updatedAt"
            ] as [String : AnyObject]
        if self.studentLocations?.count == 0 {
            self.hud?.label.text = "Getting Student Data...."
            hud?.show(animated: true)
            
            parseSingleton.getStudentLocationData(methodParameters: parameters) { (error) in
                if error == nil {
                    self.studentLocations = self.parseSingleton.studentLocations
                    DispatchQueue.main.async {
                        self.hud?.label.text = "Setting the arena for the seven kingdoms"
                        self.hud?.hide(animated: true, afterDelay: 2)
                        self.setupUIForTheMapViewWithStudentLocationData()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.hud?.hide(animated: true)
                        TSMessage.showNotification(in: self, title: "Error", subtitle: error, type: .error)
                    }
                }
            }
        }
        else {
            setupUIForTheMapViewWithStudentLocationData()
        }
    }
    
    func setupUIForTheMapViewWithStudentLocationData() {
        print("self.studentLocations - \(self.studentLocations)")
        var annotations: [MKPointAnnotation]! = []
        
        for student in self.studentLocations {
            let annotation = MKPointAnnotation()
            if student.coordinate != nil {
                annotation.coordinate = student.coordinate!
                if let firstName = student.firstName, let lastName = student.lastName {
                    let name = firstName + " " + lastName
                    annotation.title = name
                }
                else {
                    annotation.title = "Name not found"
                }
                
                if let mediaURL = student.mediaURL {
                    annotation.subtitle = mediaURL
                }
                else {
                    annotation.subtitle = "URL not found"
                }
                mapView.addAnnotation(annotation)
                annotations?.append(annotation)
            }
        }
        
        if annotations.count > 0 {
            mapView.showAnnotations(annotations, animated: true)
        }
    }
}
