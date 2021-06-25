//
//  AddCustomMealViewController.swift
//  KTA
//
//  Created by qadeem on 03/03/2021.
//

import UIKit
import Firebase

class AddCustomMealViewController: UIViewController {

    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtMealName: UITextField!
    @IBOutlet weak var txtProtiens: UITextField!
    @IBOutlet weak var txtCarbs: UITextField!
    @IBOutlet weak var txtFats: UITextField!
    
    
    @IBOutlet weak var btnSave: UIButton!
    var customMeal = CustomMeal(mealId: 0, mealName: "", calories: 0, fats: 0, protien: 0, carbs: 0)
    var editingCustomMeal = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    
    func initViews() {
        btnSave.layer.cornerRadius = 20.0
        
        if (editingCustomMeal) {
            txtTitle.text = "Edit Meal - \(customMeal.mealName)"
            txtMealName.text = customMeal.mealName
            
            txtProtiens.text = String(customMeal.protien)
            txtCarbs.text = String(customMeal.carbs)
            txtFats.text = String(customMeal.fats)
        }
        
        addDoneButtonOnKeyboard()
    }
    
    func setDetails(mealDetails: CustomMeal) {
        self.customMeal = mealDetails
        editingCustomMeal = true
    }
    
    @IBAction func addCustomMeal(_ sender: Any) {
        if (editingCustomMeal) {
            updateCustomMeal()
        } else {
            addNewCustomMeal()
        }
    }
    
    func updateCustomMeal() {
        let fats = Int(txtFats.text!) ?? 0
        let protiens = Int(txtProtiens.text!) ?? 0
        let carbs = Int(txtCarbs.text!) ?? 0
        let calories: Int = (fats * 9) + (protiens * 4) + (carbs * 4)
        
        let customMeal = CustomMeal(mealId: self.customMeal.mealId, mealName: txtMealName.text!, calories: calories, fats: Int(txtFats.text!) ?? 0, protien: Int(txtProtiens.text!) ?? 0, carbs: Int(txtCarbs.text!) ?? 0 )
        
        let isUpdate = DatabaseManager.getInstance().updateCustomMeal(customMeal)
        
        if (isUpdate) {
            Analytics.logEvent("update_custom_meal", parameters: ["custom_meal_name": txtMealName.text!])
            
            let alert = UIAlertController(title: "Success", message: "Custom meal updated Succcessfully", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                
                let nc = NotificationCenter.default
                let mealInfoDict:[String: CustomMeal] = ["mealInfo": customMeal]
                nc.post(name: Notification.Name("updateCustomMeal"), object: nil, userInfo: mealInfoDict)
                nc.post(name: Notification.Name("refreshCustomMeals"), object: nil)
                
                self.navigationController?.popViewController(animated: true);
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addNewCustomMeal() {
        let fats = Int(txtFats.text!) ?? 0
        let protiens = Int(txtProtiens.text!) ?? 0
        let carbs = Int(txtCarbs.text!) ?? 0
        let calories: Int = (fats * 9) + (protiens * 4) + (carbs * 4)
        
        let customMeal = CustomMeal(mealId: 0, mealName: txtMealName.text!, calories: calories, fats: Int(txtFats.text!) ?? 0, protien: Int(txtProtiens.text!) ?? 0, carbs: Int(txtCarbs.text!) ?? 0 )
        
        let isSave = DatabaseManager.getInstance().addCustomMeal(customMeal)
        
        if (isSave) {
            Analytics.logEvent("create_custom_meal", parameters: ["custom_meal_name": txtMealName.text!])
            
            let alert = UIAlertController(title: "Success", message: "Custom meal added Succcessfully", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("refreshCustomMeals"), object: nil)
                
                self.navigationController?.popViewController(animated: true);
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        txtMealName.inputAccessoryView = doneToolbar
        txtProtiens.inputAccessoryView = doneToolbar
        txtCarbs.inputAccessoryView = doneToolbar
        txtFats.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        txtMealName.resignFirstResponder()
        txtProtiens.resignFirstResponder()
        txtCarbs.resignFirstResponder()
        txtFats.resignFirstResponder()
    }
}
