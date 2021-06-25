//
//  CustomMealsDetailsViewController.swift
//  KTA
//
//  Created by qadeem on 03/03/2021.
//

import UIKit
import Firebase

class CustomMealsDetailsViewController: UIViewController {
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var nutrtionInfoLabel: UILabel!
    @IBOutlet weak var btnTrack: UIButton!
    
    var customMeal = CustomMeal(mealId: 0, mealName: "", calories: 0, fats: 0, protien: 0, carbs: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent("view_custom_meal_details", parameters: nil)
        initViews()
    }
    
    func setData(mealDetails: CustomMeal) {
        self.customMeal = mealDetails
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.updateCustomMeal(_:)), name: Notification.Name("updateCustomMeal"), object: nil)
    }
    
    func initViews() {
        btnTrack.layer.cornerRadius = 20.0
        
        setDetails()
    }
    
    func setDetails() {
        mealName.text = customMeal.mealName
        nutrtionInfoLabel.text = "Fats • \(customMeal.fats)g Proteins • \(customMeal.protien)g Carbs • \(customMeal.carbs)g"
    }
    
    @objc func updateCustomMeal(_ notification: NSNotification) {
        if let mealInfo = notification.userInfo?["mealInfo"] as? CustomMeal {
            self.customMeal = mealInfo
            self.setDetails()
        }
    }
    
    @IBAction func editCustomMeal(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddCustomMealViewController") as! AddCustomMealViewController
        vc.setDetails(mealDetails: customMeal)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func trackMeal(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "trackMealViewController") as! trackMealViewController
        vc.setCustomMeal(mealDetails: self.customMeal)
        vc.modalPresentationStyle = .popover
        present(vc, animated: true)
    }
}
