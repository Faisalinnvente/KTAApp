//
//  LogWeightViewController.swift
//  KTA
//
//  Created by qadeem on 19/02/2021.
//

import UIKit
import Firebase

class LogWeightViewController: UIViewController {
    @IBOutlet weak var txtWeightLBS: UITextField!
    @IBOutlet weak var btnLogWeight: UIButton!
    
    var weightLogging: [WeightTracking] = []
    var weightLogged = false
    
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var btnPreviousDate: UIButton!
    @IBOutlet weak var btnNextDate: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    // date picker control related
    let formatter = DateFormatter()
    
    var selectedDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDatePickerView()
        initViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("weightLogged"), object: nil, userInfo: nil)
    }
    
    func initViews() {
        btnLogWeight.layer.cornerRadius = 25.0
        
        btnBack.layer.cornerRadius = 10
        btnBack.layer.borderWidth = 1
        btnBack.layer.borderColor = UIColor.black.cgColor
        
        addDoneButtonOnKeyboard()
        getData()
    }
    
    func getData() {
        self.weightLogging = DatabaseManager.getInstance().getWeightTracking()
        
        setDetails()
    }
    
    func setDetails() {
        lblSelectedDate.text = selectedDate
        var loggedWeight = 0
        
        for weight in self.weightLogging {
            if (weight.date == self.selectedDate) {
                weightLogged = true
                loggedWeight = weight.weight
            }
        }
        
        txtWeightLBS.text = "\(loggedWeight)"
    }
    
    func initDatePickerView() {
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        selectedDate = formatter.string(from: Date())
    }
    
    var weightLoggedToday = WeightTracking(ID: 0, weight: 0, date: "")
    
    @IBAction func logWeightClicked(_ sender: Any) {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .full
        formatter1.timeStyle = .full
        
        weightLogged = false
        
        for weight in self.weightLogging {
            if (weight.date == self.selectedDate) {
                weightLogged = true
            }
        }
        
        self.weightLoggedToday = WeightTracking(ID: 0, weight: Int(txtWeightLBS.text!) ?? 0, date: selectedDate)
        var isSave = false
        
        if (!weightLogged) {
            Analytics.logEvent("weight_added", parameters: ["date": formatter1.string(from: Date()), "body_weight": txtWeightLBS.text!])
            isSave = DatabaseManager.getInstance().trackWeight(self.weightLoggedToday)
        } else {
            Analytics.logEvent("weight_updated", parameters: ["date": formatter1.string(from: Date()), "body_weight": txtWeightLBS.text!])
            isSave = DatabaseManager.getInstance().updateWeight(self.weightLoggedToday)
        }
        
        if (isSave) {
            let alert = UIAlertController(title: "Success", message: "Weight tracked Succcessfully", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectPrevDate(_ sender: Any) {
        let currentDate = formatter.date(from: selectedDate as String)!
        let daysToAdd = -1
        var newDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: currentDate)
        
        selectedDate = formatter.string(from: newDate!)
        initViews()
    }
    
    @IBAction func selectNextDate(_ sender: Any) {
        let currentDate = formatter.date(from: selectedDate as String)!
        let daysToAdd = 1
        var newDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: currentDate)
        
        selectedDate = formatter.string(from: newDate!)
        initViews()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        txtWeightLBS.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        txtWeightLBS.resignFirstResponder()
    }
}
