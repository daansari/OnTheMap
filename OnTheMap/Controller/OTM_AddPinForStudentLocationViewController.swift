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
import TSMessages
import MBProgressHUD

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
    var locationManager = CLLocationManager()
    var mapItems: [MKMapItem] = []
    var hud: MBProgressHUD?
    var currentLocationCoordinate: CLLocationCoordinate2D! = nil
    let isEditMode: Bool = false
    let currentStudentLocation: StudentLocation? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        parseSingleton = ParseDataSingleton.sharedInstance
        
        hud = MBProgressHUD.init(view: self.view)
        hud?.animationType = .zoom
        hud?.mode = .indeterminate
        self.view.addSubview(hud!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    // MARK: IBAction
    
    @IBAction func didTapCancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapFindOnMapBtn(_ sender: Any) {
        if (enterYourLocationTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  {
            TSMessage.showNotification(in: self, title: "Error", subtitle: "Location cannot be empty!", type: .error)
            hud?.hide(animated: true)
        }
        else {
            enterYourLocationTextField.resignFirstResponder()
            hud?.label.text = "Looking up"
            hud?.detailsLabel.text = enterYourLocationTextField.text
            hud?.show(animated: true)
            lookupCoordinatesFor(address: enterYourLocationTextField.text!, onCompletion: { (error) in
                if error == nil {
                    if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                        print("map items: \(self.mapItems)")
                    }
                    DispatchQueue.main.async {
                        self.hud?.hide(animated: true)
                        if self.mapItems.count > 0 {
                            let mapItem = self.mapItems[0]
                            let pin = MKPointAnnotation()
                            pin.coordinate = mapItem.placemark.coordinate
                            pin.title = mapItem.name
                            self.mapView.addAnnotation(pin)
                            let viewRegion = MKCoordinateRegionMakeWithDistance(pin.coordinate, 500, 500)
                            self.mapView.setRegion(viewRegion, animated: false)
                            self.currentLocationCoordinate = pin.coordinate
                        }
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
                }
                else {
                    DispatchQueue.main.async {
                        TSMessage.showNotification(in: self, title: "Error", subtitle: error, type: .error)
                        self.hud?.hide(animated: true)
                    }
                }
            })
        }
    }
    
    @IBAction func didTapSubmitBtn(_ sender: Any) {
        if (enterLinkToShareTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  {
            TSMessage.showNotification(in: self, title: "Error", subtitle: "URL cannot be empty!", type: .error)
            hud?.hide(animated: true)
        }
        else {
            if isEditMode == false {
                hud?.label.text = "Saving Data for"
                hud?.detailsLabel.text = UserDefaults.standard.string(forKey: Constants.Udacity.FirstName)! + " " + UserDefaults.standard.string(forKey: Constants.Udacity.LastName)!
                hud?.show(animated: true)
                let parameters = [
                    "mapString": enterLinkToShareTextField.text!,
                    "mediaURL": enterLinkToShareTextField.text!,
                    "latitude": self.currentLocationCoordinate.latitude,
                    "longitude": self.currentLocationCoordinate.longitude
                    ] as [String : AnyObject]
                parseSingleton.postStudentLocationData(methodParameters: parameters, onCompletion: { (error) in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.hud?.hide(animated: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            TSMessage.showNotification(in: self, title: "Error", subtitle: error, type: .message)
                            self.hud?.hide(animated: true)
                        }
                    }
                })
            }
            else {
                let parameters = [
                    "mapString": enterLinkToShareTextField.text!,
                    "mediaURL": enterLinkToShareTextField.text!,
                    "latitude": self.currentLocationCoordinate.latitude,
                    "longitude": self.currentLocationCoordinate.longitude
                    ] as [String : AnyObject]
                parseSingleton.putStudentLocationData(methodParameters: parameters, studentLocation: currentStudentLocation!, onCompletion: { (error) in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.hud?.hide(animated: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            TSMessage.showNotification(in: self, title: "Error", subtitle: error, type: .message)
                            self.hud?.hide(animated: true)
                        }
                    }
                })
            }
        }
    }
}

extension OTM_AddPinForStudentLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
