//
//  OTM_StudentsTableUserInterfaceExtension.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/21/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import Foundation
import TSMessages

extension OTM_StudentsTableViewController {
    // MARK: Manage Student Location Data
    func getStudentLocations() {
        let parameters = [
            Constants.ParseParameterKeys.Limit: 100,
            Constants.ParseParameterKeys.Order: "-updatedAt"
            ] as [String : AnyObject]
        if self.studentLocationSingleton.studentLocations?.count == 0 {
            self.hud?.label.text = "Getting Student Data...."
            hud?.show(animated: true)
            
            parseSingleton.getStudentLocationData(methodParameters: parameters) { (error) in
                if error == nil {
                    DispatchQueue.main.async {
                        self.hud?.label.text = "Setting the arena for the seven kingdoms"
                        self.hud?.hide(animated: true, afterDelay: 0.5)
                        self.tableView.reloadData()
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
            self.tableView.reloadData()
            if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                print("self.studentLocationSingleton.studentLocations - \(self.studentLocationSingleton.studentLocations)")
            }
        }
    }
}
