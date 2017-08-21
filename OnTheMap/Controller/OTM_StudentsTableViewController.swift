//
//  OTM_StudentsTableViewController.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/18/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import UIKit

import MBProgressHUD
import TSMessages
import MBProgressHUD

class OTM_StudentsTableViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pinBtn: UIBarButtonItem!
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    
    var parseSingleton: ParseDataSingleton!
    var udacitySingleton: UdacitySingleton!
    var studentLocations: [StudentLocation]! = []
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        parseSingleton = ParseDataSingleton.sharedInstance
        udacitySingleton = UdacitySingleton.sharedInstance
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
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
        self.studentLocations = []
        getStudentLocations()
    }

    @IBAction func didTapLogoutBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            DispatchQueue.main.async {
                self.hud?.label.text = "Logging Out"
                self.hud?.show(animated: true)
            }
            self.udacitySingleton.deleteLoginSessionForStudent(methodParameters: [:], onCompletion: { (error) in
                if error == nil {
                    DispatchQueue.main.async {
                        self.hud?.hide(animated: true)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controllerName = "LoginViewController"
                        
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: controllerName)
                        initialViewController.modalTransitionStyle = .flipHorizontal
                        self.present(initialViewController, animated: true) {
                            
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.hud?.hide(animated: true)
                        TSMessage.showNotification(in: self, title: "Error", subtitle: error, type: .error)
                    }
                }
            })
        })
        alert.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "No", style: .destructive, handler: { (action) in
        })
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
}


