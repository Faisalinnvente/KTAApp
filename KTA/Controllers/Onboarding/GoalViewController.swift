//
//  GoalViewController.swift
//  KTA
//
//  Created by qadeem on 07/02/2021.
//

import UIKit
import Firebase

class GoalViewController: UIViewController {
    
    @IBOutlet weak var lblHealthier: UILabel!
    @IBOutlet weak var lblLoose: UILabel!
    @IBOutlet weak var lblGain: UILabel!
    

    @IBOutlet weak var viewTrain: UIView!
    @IBOutlet weak var viewGetLean: UIView!
    @IBOutlet weak var viewBuildMuscle: UIView!
    
    @IBOutlet weak var lblTrain: UILabel!
    @IBOutlet weak var lblLeaner: UILabel!
    @IBOutlet weak var lblMuscle: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    var isGoalSelected: Bool =  false;
    var selectedGoal = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("start_setting_goals", parameters: nil)
        
        initViews()
    }
    
    func initViews() {
        addMaskedCorner(view: bottomView, size: 30.0)
        
        addMaskedCorner(view: viewTrain, size: 30.0)
        addMaskedCorner(view: viewGetLean, size: 30.0)
        addMaskedCorner(view: viewBuildMuscle, size: 30.0)
        
        addGestures()
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
    
    func addGestures() {
        let eatAndTrainGesture = UITapGestureRecognizer(target: self, action: #selector(eatAndTrainTapped(_:)))
        eatAndTrainGesture.numberOfTapsRequired = 1
        eatAndTrainGesture.numberOfTouchesRequired = 1
        
        viewTrain.addGestureRecognizer(eatAndTrainGesture);
        viewTrain.isUserInteractionEnabled = true
        
        let getLeanerGesture = UITapGestureRecognizer(target: self, action: #selector(getLeanTapped(_:)))
        getLeanerGesture.numberOfTapsRequired = 1
        getLeanerGesture.numberOfTouchesRequired = 1
        
        viewGetLean.addGestureRecognizer(getLeanerGesture);
        viewGetLean.isUserInteractionEnabled = true
        
        let buildMuscleGesture = UITapGestureRecognizer(target: self, action: #selector(buildMuscleTapped(_:)))
        buildMuscleGesture.numberOfTapsRequired = 1
        buildMuscleGesture.numberOfTouchesRequired = 1
        
        viewBuildMuscle.addGestureRecognizer(buildMuscleGesture);
        viewBuildMuscle.isUserInteractionEnabled = true
    }
    
    @objc func eatAndTrainTapped(_ gesture: UITapGestureRecognizer) {
        resetSelections()
        self.viewTrain.backgroundColor = UIColor(red: 0.612, green: 0.800, blue: 0.396, alpha: 1.0)
        self.lblTrain.textColor = UIColor.white
        self.lblHealthier.textColor = UIColor.white
        isGoalSelected = true
        
        //event
        Analytics.logEvent("select_target_goal", parameters: ["target_goal": "be_healthier"])
        selectedGoal = "be_healthier"
        UserDefaults.standard.set(Goal.EatAndTrain.rawValue, forKey: "userGoal")
    }
    
    @objc func getLeanTapped(_ gesture: UITapGestureRecognizer) {
        resetSelections()
        self.viewGetLean.backgroundColor = UIColor(red: 0.612, green: 0.800, blue: 0.396, alpha: 1.0)
        self.lblLeaner.textColor = UIColor.white
        self.lblLoose.textColor = UIColor.white
        isGoalSelected = true
        
        // event
        Analytics.logEvent("select_target_goal", parameters: ["target_goal": "lose_weight"])
        selectedGoal = "lose_weight"
        UserDefaults.standard.set(Goal.GetLeaner.rawValue, forKey: "userGoal")
    }
    
    @objc func buildMuscleTapped(_ gesture: UITapGestureRecognizer) {
        resetSelections()
        self.viewBuildMuscle.backgroundColor = UIColor(red: 0.612, green: 0.800, blue: 0.396, alpha: 1.0)
        self.lblMuscle.textColor = UIColor.white
        self.lblGain.textColor = UIColor.white
        isGoalSelected = true
        
        //event
        Analytics.logEvent("select_target_goal", parameters: ["target_goal": "gain_weight"])
        selectedGoal = "gain_weight"
        UserDefaults.standard.set(Goal.BuildMuscle.rawValue, forKey: "userGoal")
    }
    
    func resetSelections() {
        self.viewTrain.backgroundColor = UIColor.white
        self.viewGetLean.backgroundColor = UIColor.white
        self.viewBuildMuscle.backgroundColor = UIColor.white
        
        self.lblHealthier.textColor = UIColor.link
        self.lblLoose.textColor = UIColor.link
        self.lblGain.textColor = UIColor.link
        
        self.lblTrain.textColor = UIColor(red: 0.592, green: 0.592, blue: 0.659, alpha: 1.0)
        self.lblLeaner.textColor = UIColor(red: 0.592, green: 0.592, blue: 0.659, alpha: 1.0)
        self.lblMuscle.textColor = UIColor(red: 0.592, green: 0.592, blue: 0.659, alpha: 1.0)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        if isGoalSelected {
            
            // property
            Analytics.setUserProperty(selectedGoal, forName: "target_goal")
            
            let vc = storyboard?.instantiateViewController(identifier: "SignInViewController") as! SignInViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please select your goal to proceed", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
