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

class OTM_StudentsMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pinBtn: UIBarButtonItem!
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    var parseSingleton: ParseDataSingleton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        parseSingleton = ParseDataSingleton.sharedInstance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    @IBAction func didTapPinBtn(_ sender: Any) {
    }
    
    @IBAction func didTapRefreshBtn(_ sender: Any) {
    }
    
    @IBAction func didTapLogoutBtn(_ sender: Any) {
    }
    

}
