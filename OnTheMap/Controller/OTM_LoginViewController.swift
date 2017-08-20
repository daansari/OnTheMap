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

class OTM_LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextField: JVFloatLabeledTextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    var udacitySingleton: UdacitySingleton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        udacitySingleton = UdacitySingleton.sharedInstance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: IBAction
    
    @IBAction func didTapLoginBtn(_ sender: Any) {
    }
    
    @IBAction func didTapSignUpBtn(_ sender: Any) {
        let signUpWebVC = SwiftModalWebVC(urlString: Constants.Udacity.SignUpURL, theme: .lightBlack, dismissButtonStyle: .cross)
        signUpWebVC.delegate = self as? UINavigationControllerDelegate
        self.present(signUpWebVC, animated: true, completion: nil)
    }
}

extension OTM_LoginViewController: SwiftWebVCDelegate {
    
    func didStartLoading() {
        print("Started loading.")
    }
    
    func didFinishLoading(success: Bool) {
        print("Finished loading. Success: \(success).")
    }
}

