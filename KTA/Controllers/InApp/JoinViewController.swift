//
//  JoinViewController.swift
//  KTA
//
//  Created by qadeem on 28/03/2021.
//

import UIKit
import Firebase

class JoinViewController: UIViewController {
    @IBOutlet weak var btnJoin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    
    func initViews() {
        btnJoin.layer.cornerRadius = 20.0
    }

    @IBAction func joinClicked(_ sender: UIButton) {
        //event
        Analytics.logEvent("select_join_the_movement", parameters: nil)
        
        let vc = storyboard?.instantiateViewController(identifier: "InAppPurchaseViewController") as! InAppPurchaseViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
