//
//  DurationViewController.swift
//  KTA
//
//  Created by qadeem on 07/02/2021.
//

import UIKit
import Firebase

class DurationViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var weeksSlider: UISlider!
    @IBOutlet weak var weeksValue: UILabel!
    
    @IBOutlet weak var weeksLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    var weeks = 50.0;
    var weightPerweek = 0.0;
    
    //Data Collected
    var goal: String = ""
    var gender: String = ""
    var age: Int = 0
    var height: Int = 0
    var currentWeight: Int = 0
    var targetWeight: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMaskedCorner(view: bottomView, size: 30.0)

        weeksSlider.minimumTrackTintColor = UIColor(named: "Primary")
        weeksSlider.maximumTrackTintColor = UIColor(named: "Primary")
        weeksSlider.value = Float(weeks)
        
        weeksValue.text = "\(Int(weeksSlider.value))"
        weeks = Double(weeksSlider.value)
        //weightPerweek  = weeks
        //weeksSlider.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        
        self.getAllSavedData()
        
        self.setWeeksDurationsLabelsData()
    }
    
    func addMaskedCorner(view: UIView, size: CGFloat) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.1
        
        view.layer.cornerRadius = size
        view.layer.maskedCorners = [.layerMaxXMinYCorner]
    }
    
    func getAllSavedData() {
        goal = UserDefaults.standard.string(forKey: "userGoal")!
        gender = UserDefaults.standard.string(forKey: "gender")!
        age = UserDefaults.standard.integer(forKey: "age")
        height = UserDefaults.standard.integer(forKey: "height")
        currentWeight = UserDefaults.standard.integer(forKey: "currentWeight")
        targetWeight = UserDefaults.standard.integer(forKey: "targetWeight")
    }
    
    func setWeeksDurationsLabelsData() {
        weeksValue.text = "\(Int(weeksSlider.value))"
        weeks = Double(weeksSlider.value)
        weeksLabel.text = "\(Int(weeksSlider.value)) Weeks"
        
        weightPerweek = Double((currentWeight - targetWeight)) / weeks
        weightLabel.text = "Lose \(round(1000*weightPerweek)/1000) kg / week"
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        UserDefaults.standard.set(weeks, forKey: "weeks")
        
        //event
        Analytics.logEvent("select_target_goal_time", parameters: ["week_target_goals": weeks])
        Analytics.setUserProperty(String(weeks), forName: "week_target_goals")
        
        // setting Default meal Tracking Values
        UserDefaults.standard.set(20, forKey: "weeklyTarget")
        UserDefaults.standard.set(80, forKey: "monthlyTarget")
        
        let vc = storyboard?.instantiateViewController(identifier: "JoinViewController") as! JoinViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func weeksDurationChanged(_ sender: CustomUISlider) {
        setWeeksDurationsLabelsData()
    }
}
