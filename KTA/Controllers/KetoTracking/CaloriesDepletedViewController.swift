//
//  CaloriesDepletedViewController.swift
//  KTA
//
//  Created by qadeem on 09/03/2021.
//

import UIKit
import Firebase

class CaloriesDepletedViewController: UIViewController {
    @IBOutlet weak var txtCaloriesDepleted: UITextField!
    @IBOutlet weak var btnLogCalories: UIButton!
    
    // date picker control related
    let formatter = DateFormatter()
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var btnPreviousDate: UIButton!
    @IBOutlet weak var btnNextDate: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var selectedDate = ""
    
    var caloriesDepleted: [CaloriesDepleted] = []
    var caloriesLogged = false

    override func viewDidLoad() {
        super.viewDidLoad()

        initDatePickerView()
        initViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("caloriesDepleted"), object: nil, userInfo: nil)
    }
    
    func initViews() {
        btnLogCalories.layer.cornerRadius = 25.0
        
        btnBack.layer.cornerRadius = 10
        btnBack.layer.borderWidth = 1
        btnBack.layer.borderColor = UIColor.black.cgColor
        
        addDoneButtonOnKeyboard()
        getData()
    }
    
    func initDatePickerView() {
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        selectedDate = formatter.string(from: Date())
    }
    
    func getData() {
        self.caloriesDepleted = DatabaseManager.getInstance().getDepletedCalories()
        
        setDetails()
    }
    
    func setDetails() {
        lblSelectedDate.text = selectedDate
        var loggedCals = 0
        
        for dailyDepletion in self.caloriesDepleted {
            if (dailyDepletion.date == self.selectedDate) {
                caloriesLogged = true
                loggedCals = dailyDepletion.calories
            }
        }
        
        txtCaloriesDepleted.text = "\(loggedCals)"
    }
    
    var caloriesDepletedToday = CaloriesDepleted(ID: 0, calories: 0, date: "")
    
    @IBAction func logCaloriesDepleted(_ sender: Any) {
        caloriesLogged = false
        
        for dailyDepletion in self.caloriesDepleted {
            if (dailyDepletion.date == self.selectedDate) {
                caloriesLogged = true
            }
        }
        
        self.caloriesDepletedToday = CaloriesDepleted(ID: 0, calories: Int(txtCaloriesDepleted.text!) ?? 0, date: self.selectedDate)
        var isSave = false
        
        if (!caloriesLogged) {
            isSave = DatabaseManager.getInstance().trackCaloriesDepleted(self.caloriesDepletedToday)
        } else {
            isSave = DatabaseManager.getInstance().updateCaloriesDepleted(self.caloriesDepletedToday)
        }
        
        if (isSave) {
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .full
            formatter1.timeStyle = .full
            Analytics.logEvent("calories_depleted_logged", parameters: ["date": formatter1.string(from: Date()), "depleted_calories": txtCaloriesDepleted.text!])
            
            let alert = UIAlertController(title: "Success", message: "Depleted Calories tracked Succcessfully", preferredStyle: UIAlertController.Style.alert)
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

        txtCaloriesDepleted.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        txtCaloriesDepleted.resignFirstResponder()
    }
}
