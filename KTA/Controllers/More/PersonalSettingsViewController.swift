//
//  PersonalSettingsViewController.swift
//  KTA
//
//  Created by qadeem on 18/03/2021.
//

import UIKit

class PersonalSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func updateActivity(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "UpdateActivityViewController") as! UpdateActivityViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeAge(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "UpdateAgeViewController") as! UpdateAgeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeHeight(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "UpdateHeightViewController") as! UpdateHeightViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeCurrentWeight(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "UpdateCurrentWeightViewController") as! UpdateCurrentWeightViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeTargetWeight(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "UpdateTargetWeightViewController") as! UpdateTargetWeightViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
