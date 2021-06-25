//
//  SignInViewController.swift
//  KTA
//
//  Created by qadeem on 07/02/2021.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var viewMaleIcon: UIView!
    @IBOutlet weak var viewFemaleIcon: UIView!
    
    var gender: String = "";
    var isGenderSelected: Bool =  false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMaskedCorner(view: bottomView, size: 30.0)
        addCornerRadius(view: viewMaleIcon, radius: 5.0)
        addCornerRadius(view: viewFemaleIcon, radius: 5.0)
        
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
    
    func addCornerRadius(view: UIView, radius: CGFloat) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.1
        view.layer.cornerRadius = radius
    }
    
    func addGestures() {
        let maleGesture = UITapGestureRecognizer(target: self, action: #selector(maleTapped(_:)))
        maleGesture.numberOfTapsRequired = 1
        maleGesture.numberOfTouchesRequired = 1
        
        viewMaleIcon.addGestureRecognizer(maleGesture);
        viewMaleIcon.isUserInteractionEnabled = true
        
        let femaleGesture = UITapGestureRecognizer(target: self, action: #selector(femaleTapped(_:)))
        femaleGesture.numberOfTapsRequired = 1
        femaleGesture.numberOfTouchesRequired = 1
        
        viewFemaleIcon.addGestureRecognizer(femaleGesture);
        viewFemaleIcon.isUserInteractionEnabled = true
    }
    
    @objc func maleTapped(_ gesture: UITapGestureRecognizer) {
        resetSelections()
        self.viewMaleIcon.backgroundColor = UIColor(red: 0.612, green: 0.800, blue: 0.396, alpha: 1.0)
        isGenderSelected = true
        
        //event
        Analytics.logEvent("select_gender", parameters: ["gender": "male"])
        gender = "male"
        UserDefaults.standard.set(Gender.Male.rawValue, forKey: "gender")
    }
    
    @objc func femaleTapped(_ gesture: UITapGestureRecognizer) {
        resetSelections()
        self.viewFemaleIcon.backgroundColor = UIColor(red: 0.612, green: 0.800, blue: 0.396, alpha: 1.0)
        isGenderSelected = true
        
        //event
        Analytics.logEvent("select_gender", parameters: ["gender": "female"])
        gender = "female"
        UserDefaults.standard.set(Gender.Female.rawValue, forKey: "gender")
    }
    
    
    func resetSelections() {
        self.viewMaleIcon.backgroundColor = UIColor.white
        self.viewFemaleIcon.backgroundColor = UIColor.white
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        if isGenderSelected {
            //property
            Analytics.setUserProperty(gender, forName: "gender")
            
            let vc = storyboard?.instantiateViewController(identifier: "AgeViewController") as! AgeViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please select your gender to proceed", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
