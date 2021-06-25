//
//  trackMealViewController.swift
//  KTA
//
//  Created by qadeem on 04/03/2021.
//

import UIKit
import Firebase

class trackMealViewController: UIViewController {
    @IBOutlet weak var lblMealName: UILabel!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var lblServings: UILabel!
    
    @IBOutlet weak var stepperControl: UIStepper!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var customMeal = CustomMeal(mealId: 0, mealName: "", calories: 0, fats: 0, protien: 0, carbs: 0)
    var recepie: RecepieElement = RecepieElement()
    
    var mealType = 0 // 1 for custom meals, 2 for meals from database
    var selectedDate = ""
    var month = 0
    var week = 0
    
    
    let formatter = DateFormatter()
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var btnPreviousDate: UIButton!
    @IBOutlet weak var btnNextDate: UIButton!
    
    // logic variables
    var alreadyExists = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDate()
        initViews()
    }
    
    func initDate() {
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        selectedDate = formatter.string(from: Date())
    }
    
    func initViews() {
        btnSave.layer.cornerRadius = 20.0
        
        btnBack.layer.cornerRadius = 10
        btnBack.layer.borderWidth = 1
        btnBack.layer.borderColor = UIColor.black.cgColor
    
        setDetails()
    }
    
    @IBAction func changeServings(_ sender: Any) {
        var cals = 0.0
        
        if mealType == 1 {
            cals = Double(customMeal.calories) * stepperControl.value
        } else {
            cals = recepie.nutrition[0].calories * stepperControl.value
        }
        
        lblCalories.text =  "\(cals) kcal"
        lblServings.text = "\(stepperControl.value) servings"
    }
    
    func setCustomMeal(mealDetails: CustomMeal) {
        customMeal = mealDetails
        mealType = 1
    }
    
    public func setRecepie(recepieDetails: RecepieElement) {
        recepie = recepieDetails
        mealType = 2
    }
    
    func setDetails() {
        lblServings.text = "\(stepperControl.value) servings"
        lblSelectedDate.text = selectedDate
        var mealTracking: [MealTracking] = [MealTracking]()
        
        if mealType == 1 {
            lblMealName.text = customMeal.mealName
            lblCalories.text = "\(customMeal.calories) kcal"
            
            mealTracking = DatabaseManager.getInstance().getIfAlreadyTracked(String(customMeal.mealId), date: selectedDate)
        } else {
            lblMealName.text = recepie.name
            lblCalories.text = "\(recepie.nutrition[0].calories) kcal"
            
            mealTracking = DatabaseManager.getInstance().getIfAlreadyTracked(recepie.recipieID, date: selectedDate)
        }
        
        if mealTracking.count > 0 {
            self.mealTracking = mealTracking[0]
            let cals = mealTracking[0].calories * mealTracking[0].servings
            lblCalories.text =  "\(cals) kcal"
            lblServings.text = "\(mealTracking[0].servings) servings"
            
            stepperControl.value = Double(mealTracking[0].servings)
            alreadyExists = true
        } else {
            
            lblCalories.text =  "0 kcal"
            lblServings.text = "0 servings"
            stepperControl.value = 0.0
            alreadyExists = false
        }
    }
    
    var mealTracking = MealTracking(trackingId: 0, mealId: "", mealName: "", calories: 0, fats: 0, protien: 0, carbs: 0, servings: 0, date: "", week: 0, month: 0)
    
    @IBAction func trackMeal(_ sender: Any) {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .full
        formatter1.timeStyle = .full
        
        if stepperControl.value == 0.0  {
            let alert = UIAlertController(title: "Error", message: "Please select servings to track the meal", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let calendar = Calendar.current
        let curDate = formatter.date(from: selectedDate as String)!
        let components = calendar.dateComponents([.weekOfYear, .month , .weekOfMonth], from: curDate)
        
        month = components.month ?? 0
        week = components.weekOfYear ?? 0
        
        if (mealType == 1) {
            self.mealTracking = MealTracking(trackingId: 0, mealId: String(self.customMeal.mealId), mealName: self.customMeal.mealName, calories: self.customMeal.calories, fats: self.customMeal.fats, protien: self.customMeal.protien, carbs: self.customMeal.carbs, servings: Int(stepperControl.value), date:  self.selectedDate, week: self.week, month: self.month)
            
            Analytics.logEvent("track_custom_meal", parameters: ["date": formatter1.string(from: Date())])
            
        } else {
            self.mealTracking = MealTracking(trackingId: 0, mealId: self.recepie.recipieID, mealName: self.recepie.name, calories: Int(self.recepie.nutrition[0].calories), fats: Int(self.recepie.nutrition[0].fat), protien: Int(self.recepie.nutrition[0].protein), carbs: Int(self.recepie.nutrition[0].netCarbs), servings: Int(stepperControl.value), date:  self.selectedDate, week: self.week, month: self.month)
            
            if recepie.recipieType.rawValue == "breakfast" || recepie.recipieType.rawValue == "BreakFast" {
                Analytics.logEvent("add_breakfast_tracking", parameters: ["date": formatter1.string(from: Date())])
            } else if recepie.recipieType.rawValue == "lunch" {
                Analytics.logEvent("add_lunch_tracking", parameters: ["date": formatter1.string(from: Date())])
            } else if recepie.recipieType.rawValue == "dinner" {
                Analytics.logEvent("add_dinner_tracking", parameters: ["date": formatter1.string(from: Date())])
            }
        }
        
        var isSave = false
        
        if !alreadyExists {
           isSave = DatabaseManager.getInstance().trackMeal(self.mealTracking)
        } else {
            isSave = DatabaseManager.getInstance().updateMealDetails(self.mealTracking)
        }
        
        if (isSave) {
            let alert = UIAlertController(title: "Success", message: "Meal Tracked Succcessfully", preferredStyle: UIAlertController.Style.alert)
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
}
