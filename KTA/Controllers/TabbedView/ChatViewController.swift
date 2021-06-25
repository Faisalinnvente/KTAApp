//
//  ChatViewController.swift
//  KTA
//
//  Created by qadeem on 11/02/2021.
//

import UIKit
import CustomerlySDK

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        logOutUser()
    }
    
    func initChat() {
        Customerly.sharedInstance.configure(appId: "c501a5c0")
        Customerly.sharedInstance.activateApp()
        Customerly.sharedInstance.verboseLogging = true

        //Customerly.sharedInstance.registerUser(email: "faisal.javaid6@gmail.com", user_id: "5419910", name: "Faisal javaid")
        Customerly.sharedInstance.openSupport(from: self)
    }
    
    func logOutUser() {
        Customerly.sharedInstance.logoutUser()
    }
}
