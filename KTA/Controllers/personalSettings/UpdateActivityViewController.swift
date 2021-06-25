//
//  UpdateActivityViewController.swift
//  KTA
//
//  Created by qadeem on 18/03/2021.
//

import UIKit
import SimpleCheckbox
import Firebase

class UpdateActivityViewController: UIViewController {
    @IBOutlet weak var cbModerate: Checkbox!
    @IBOutlet weak var cbHigh: Checkbox!
    
    @IBOutlet weak var btnSave: UIButton!
    
    var activityLevel = "Moderate"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Analytics.logEvent("view_update_activity_levels", parameters: nil)
        initViews()
    }
    
    func initViews() {
        btnSave.layer.cornerRadius = 20.0
        
        configCheckBoxes()
        initCheckBox()
    }
    
    func configCheckBoxes() {
        cbModerate.checkedBorderColor = .black
        cbModerate.uncheckedBorderColor = .lightGray
        
        cbHigh.checkedBorderColor = .black
        cbHigh.uncheckedBorderColor = .lightGray
        
        cbModerate.borderStyle = .circle
        cbHigh.borderStyle = .circle
        
        cbModerate.checkmarkStyle = .circle
        cbHigh.checkmarkStyle = .circle

        cbModerate.checkmarkColor = .lightGray
        cbHigh.checkmarkColor = .lightGray
        
        cbModerate.addTarget(self, action: #selector(cbModerateChanged(sender:)), for: .valueChanged)
        cbHigh.addTarget(self, action: #selector(cbHighChanged(sender:)), for: .valueChanged)
    }
    
    func initCheckBox() {
        let activityLevel = UserDefaults.standard.string(forKey: "activityLevel")
        
        if activityLevel == "Moderate" {
            setModerateActive()
        } else if activityLevel == "High" {
            setHighActive()
        }
        
        Analytics.logEvent("update_activity_levels", parameters: ["target_activity_level": activityLevel])
    }
    
    @objc func cbModerateChanged(sender: Checkbox) {
        print("checkbox value change: \(sender.isChecked)")
        
        if sender.isChecked {
            setModerateActive()
        } else {
            setHighActive()
        }
    }
    
    @objc func cbHighChanged(sender: Checkbox) {
        print("checkbox value change: \(sender.isChecked)")
        
        if sender.isChecked {
            setHighActive()
        } else {
            setModerateActive()
        }
    }
    
    func setModerateActive() {
        cbModerate.isChecked = true
        cbHigh.isChecked = false
        
        cbModerate.checkmarkColor = .black
        cbHigh.checkmarkColor = .lightGray
        
        activityLevel = "Moderate"
    }
    
    func setHighActive() {
        cbModerate.isChecked = false
        cbHigh.isChecked = true
        
        cbModerate.checkmarkColor = .lightGray
        cbHigh.checkmarkColor = .black
        
        activityLevel = "High"
    }
    
    @IBAction func saveActivityLevel(_ sender: Any) {
        UserDefaults.standard.set(self.activityLevel, forKey: "activityLevel")
        self.navigationController?.popViewController(animated: true)
    }
}
