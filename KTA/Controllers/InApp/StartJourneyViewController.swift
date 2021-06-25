//
//  StartJourneyViewController.swift
//  KTA
//
//  Created by qadeem on 28/03/2021.
//

import UIKit
import Firebase

class StartJourneyViewController: UIViewController {
    @IBOutlet weak var btnStart: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    
    func initViews() {
        btnStart.layer.cornerRadius = 20.0
    }
    
    @IBAction func startClicked(_ sender: Any) {
        //event
        Analytics.logEvent("select_start_keto_journey", parameters: nil)
        
        UserDefaults.standard.set(true, forKey: "isNewUser")
        UserDefaults.standard.set(true, forKey: "trailStarted")
        
        let vc = storyboard?.instantiateViewController(identifier: "TabBarViewController") as! TabBarViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
