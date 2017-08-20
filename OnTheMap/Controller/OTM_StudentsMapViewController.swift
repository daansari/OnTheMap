//
//  OTM_StudentsMapViewController.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/18/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import UIKit
import Foundation
import MapKit

import TSMessages
import MBProgressHUD

class OTM_StudentsMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pinBtn: UIBarButtonItem!
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    var parseSingleton: ParseDataSingleton!
    var studentLocations: [StudentLocation]! = []
    
    var hud: MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        parseSingleton = ParseDataSingleton.sharedInstance
        
        hud = MBProgressHUD.init(view: self.view)
        hud?.animationType = .zoom
        hud?.mode = .indeterminate
        self.view.addSubview(hud!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.studentLocations = parseSingleton.studentLocations
        getStudentLocations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */        
    
    // MARK: IBAction
    @IBAction func didTapPinBtn(_ sender: Any) {
    }
    
    @IBAction func didTapRefreshBtn(_ sender: Any) {
    }
    
    @IBAction func didTapLogoutBtn(_ sender: Any) {
    }
    
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
    }

}
