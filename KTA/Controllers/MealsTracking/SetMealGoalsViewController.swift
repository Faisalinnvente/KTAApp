//
//  SetMealGoalsViewController.swift
//  KTA
//
//  Created by qadeem on 20/02/2021.
//

import UIKit
import Firebase

class SetMealGoalsViewController: UIViewController {
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var txtWeekly: UITextField!
    @IBOutlet weak var txtMonthly: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        initViews()
    }
    
    func initViews() {
        btnSave.layer.cornerRadius = 20.0
        
        let weeklyTarget = UserDefaults.standard.string(forKey: "weeklyTarget")
        let monthlyTarget = UserDefaults.standard.string(forKey: "monthlyTarget")
        
        if (weeklyTarget != nil) {
            txtWeekly.text = "\(String(describing: weeklyTarget!))"
        }
        
        if (monthlyTarget != nil) {
            txtMonthly.text = "\(String(describing: monthlyTarget!))"
        }
        
        addDoneButtonOnKeyboard()
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        UserDefaults.standard.set(txtWeekly.text, forKey: "weeklyTarget")
        UserDefaults.standard.set(txtMonthly.text, forKey: "monthlyTarget")
        
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .full
        formatter1.timeStyle = .full
        
        Analytics.logEvent("edit_monthly_weekly_targets", parameters: ["monthly_targets": txtMonthly.text!, "weekly_targets": txtWeekly.text!])
        
        let alert = UIAlertController(title: "Success", message: "Target added Succcessfully", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
            self.navigationController?.popViewController(animated: true);
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        txtWeekly.inputAccessoryView = doneToolbar
        txtMonthly.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        txtWeekly.resignFirstResponder()
        txtMonthly.resignFirstResponder()
    }
}
