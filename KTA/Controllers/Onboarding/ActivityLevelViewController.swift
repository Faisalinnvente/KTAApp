//
//  ActivityLevelViewController.swift
//  KTA
//
//  Created by qadeem on 08/03/2021.
//

import UIKit
import Firebase

class ActivityLevelViewController: UIViewController {
    @IBOutlet weak var viewModerate: UIView!
    @IBOutlet weak var viewHigh: UIView!
    
    @IBOutlet weak var lblModerate: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    
    @IBOutlet weak var lblModerateSub: UILabel!
    @IBOutlet weak var lblHighSub: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    var isActivitySelected = false
    var activityLevel = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMaskedCorner(view: bottomView, size: 30.0)
        
        addMaskedCorner(view: viewHigh, size: 30.0)
        addMaskedCorner(view: viewModerate, size: 30.0)
        
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
        let moderateGesture = UITapGestureRecognizer(target: self, action: #selector(moderateTapped(_:)))
        moderateGesture.numberOfTapsRequired = 1
        moderateGesture.numberOfTouchesRequired = 1
        
        viewModerate.addGestureRecognizer(moderateGesture);
        viewModerate.isUserInteractionEnabled = true
        
        let highGesture = UITapGestureRecognizer(target: self, action: #selector(highTapped(_:)))
        highGesture.numberOfTapsRequired = 1
        highGesture.numberOfTouchesRequired = 1
        
        viewHigh.addGestureRecognizer(highGesture);
        viewHigh.isUserInteractionEnabled = true
    }
    
    @objc func moderateTapped(_ gesture: UITapGestureRecognizer) {
        resetSelections()
        self.viewModerate.backgroundColor = UIColor(red: 0.612, green: 0.800, blue: 0.396, alpha: 1.0)
        self.lblModerate.textColor = UIColor.white
        self.lblModerateSub.textColor = UIColor.white
        isActivitySelected = true
        
        //event
        Analytics.logEvent("select_activity_level", parameters: ["target_activity_level": "Moderate"])
        activityLevel = "Moderate"
        UserDefaults.standard.set(Activity.Moderate.rawValue, forKey: "activityLevel")
    }
    
    @objc func highTapped(_ gesture: UITapGestureRecognizer) {
        resetSelections()
        self.viewHigh.backgroundColor = UIColor(red: 0.612, green: 0.800, blue: 0.396, alpha: 1.0)
        self.lblHigh.textColor = UIColor.white
        self.lblHighSub.textColor = UIColor.white
        isActivitySelected = true
        
        //event
        Analytics.logEvent("select_activity_level", parameters: ["target_activity_level": "High"])
        activityLevel = "High"
        UserDefaults.standard.set(Activity.High.rawValue, forKey: "activityLevel")
    }
    
    
    func resetSelections() {
        self.viewModerate.backgroundColor = UIColor.white
        self.viewHigh.backgroundColor = UIColor.white
        
        self.lblModerate.textColor = UIColor.link
        self.lblHigh.textColor = UIColor.link
        
        self.lblModerateSub.textColor = UIColor(red: 0.592, green: 0.592, blue: 0.659, alpha: 1.0)
        self.lblHighSub.textColor = UIColor(red: 0.592, green: 0.592, blue: 0.659, alpha: 1.0)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        if isActivitySelected {
            Analytics.setUserProperty(activityLevel, forName: "target_activity_level")
            
            let vc = storyboard?.instantiateViewController(identifier: "DurationViewController") as! DurationViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please select your activity level to proceed", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    

}
