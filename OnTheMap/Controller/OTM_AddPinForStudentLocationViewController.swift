//
//  OTM_AddPinForStudentLocationViewController.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/20/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import AXWireButton
import JVFloatLabeledTextField
import ChameleonFramework
import MapKit

class OTM_AddPinForStudentLocationViewController: UIViewController {
    
    @IBOutlet weak var enterYourLocationStackView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var enterYourLocationTextField: JVFloatLabeledTextField!
    @IBOutlet weak var findOnMapBtn: AXWireButton!
    
    @IBOutlet weak var enterLinkToShareStackView: UIStackView!
    @IBOutlet weak var enterLinkToShareTextField: JVFloatLabeledTextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
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
    
    // MARK: IBAction
    
    @IBAction func didTapCancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapFindOnMapBtn(_ sender: Any) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.enterYourLocationStackView.alpha = 0
        }) { (bool) in
            self.enterYourLocationStackView.isHidden = true
            self.enterLinkToShareStackView.isHidden = false
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                self.cancelBtn.setTitleColor(UIColor.flatWhite, for: .normal)
                self.enterLinkToShareStackView.alpha = 1
            }) { (bool) in
                
            }
        }
    }
    
    @IBAction func didTapSubmitBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
