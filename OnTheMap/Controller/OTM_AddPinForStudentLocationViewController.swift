//
//  OTM_AddPinForStudentLocationViewController.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/20/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import UIKit

class OTM_AddPinForStudentLocationViewController: UIViewController {
    
    var parseSingleton: ParseDataSingleton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        parseSingleton = ParseDataSingleton.sharedInstance
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

}
