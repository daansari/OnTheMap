//
//  OTM_StudentsTableDelegateExtension.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/21/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import Foundation
import UIKit
import TSMessages

extension OTM_StudentsTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationTableViewCell", for: indexPath) as! OTM_StudentLocationTableViewCell
        
        let student = self.studentLocations[indexPath.row]
        if let firstName = student.firstName, let lastName = student.lastName {
            let name = firstName + " " + lastName
            cell.studentNameLabel.text = name
        }
        else {
            cell.studentNameLabel.text = "Name not found"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = self.studentLocations[indexPath.row]
        if let mediaURL = student.mediaURL {
            let url = URL(string: mediaURL)            
            let alert = UIAlertController(title: "Open in Safari", message: "\(mediaURL)?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            })
            alert.addAction(yesAction)
            
            let noAction = UIAlertAction(title: "No", style: .destructive, handler: { (action) in
            })
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            TSMessage.showNotification(in: self, title: "Error", subtitle: "MediaURL not found", type: .error)
        }
    }
}