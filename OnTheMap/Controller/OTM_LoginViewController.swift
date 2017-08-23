//
//  OTM_LoginViewController.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/18/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import UIKit

import JVFloatLabeledTextField
import SwiftWebVC
import MBProgressHUD
import TSMessages

class OTM_LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextField: JVFloatLabeledTextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    var udacitySingleton: UdacitySingleton!
    
    var hud: MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        udacitySingleton = UdacitySingleton.sharedInstance
        
        hud = MBProgressHUD.init(view: self.view)
        hud?.animationType = .zoom
        hud?.mode = .indeterminate
        self.view.addSubview(hud!)
    }

    // MARK: IBAction    
    @IBAction func didTapLoginBtn(_ sender: Any) {
        if (emailTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  {
            TSMessage.showNotification(in: self, title: "Email address cannot be empty!", subtitle: nil, type: .error)
            hud?.hide(animated: true)
        }
        else if  (passwordTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            TSMessage.showNotification(in: self, title: "Password cannot be empty!", subtitle: nil, type: .error)
            hud?.hide(animated: true)
        }
        else {
            hud?.label.text = "Logging In"
            hud?.detailsLabel.text = "\(emailTextField.text!)"
            hud?.show(animated: true)
            let parameters = [
                "username": emailTextField.text,
                "password": passwordTextField.text
            ] as [String: AnyObject]
            udacitySingleton.postLoginSessionForStudent(methodParameters: parameters, onCompletion: { (error) in
                if error == nil {
                    DispatchQueue.main.async {
                        self.hud?.label.text = "Fetching Student Detail for"
                    }
                    self.udacitySingleton.getInfoFromUdacityForUser(methodParameters: [:], onCompletion: { (error) in
                        if error == nil {
                            DispatchQueue.main.async {
                                self.hud?.hide(animated: true)
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let controllerName = "LoggedInTabBarController"
                                    
                                let initialViewController = storyboard.instantiateViewController(withIdentifier: controllerName)
                                initialViewController.modalTransitionStyle = .flipHorizontal
                                self.present(initialViewController, animated: true) {
                                    
                                }
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                TSMessage.showNotification(in: self, title: "Error", subtitle: error, type: .error)
                                self.hud?.hide(animated: true)
                            }
                            if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                                print("Log in error while fetching student data - \(error!)")
                            }
                        }
                    })
                }
                else {
                    DispatchQueue.main.async {
                        TSMessage.showNotification(in: self, title: "Error", subtitle: error, type: .error)
                        self.hud?.hide(animated: true)
                    }
                    if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                        print("Log in error while logging in - \(error!)")
                    }
                }
            })
        }
    }
    
    @IBAction func didTapSignUpBtn(_ sender: Any) {
        let signUpWebVC = SwiftModalWebVC(urlString: Constants.Udacity.SignUpURL, theme: .lightBlack, dismissButtonStyle: .cross)
        signUpWebVC.delegate = self as? UINavigationControllerDelegate
        signUpWebVC.title = "Udacity Sign Up"
        self.present(signUpWebVC, animated: true, completion: nil)
    }
}

extension OTM_LoginViewController: SwiftWebVCDelegate {
    
    func didStartLoading() {
        if Constants.ModeKey.Environment == Constants.ModeValue.Development {
            print("Started loading.")
        }
    }
    
    func didFinishLoading(success: Bool) {
        if Constants.ModeKey.Environment == Constants.ModeValue.Development {
            print("Finished loading. Success: \(success).")
        }
    }
}

extension OTM_LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

