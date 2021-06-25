//
//  HomeViewController.swift
//  KTA
//
//  Created by qadeem on 11/02/2021.
//

import UIKit
import UICircularProgressRing
import UserNotifications
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let baseUrl = "http://104.248.108.131:3000/api/recepies/"
    //let baseUrl = "http://127.0.0.1:3000/api/recepies/"
    
    @IBOutlet weak var ketoView: UIView!
    @IBOutlet weak var iconNext: UIImageView!
    
    @IBOutlet weak var targetsView: UIView!
    @IBOutlet weak var targetsNext: UIImageView!
    
    @IBOutlet weak var measurementsView: UIView!
    @IBOutlet weak var measurementsNext: UIImageView!
    
    // water Tracking Views
    @IBOutlet weak var waterIntakeView: UIView!
    @IBOutlet weak var waterIntakeStepper: UIStepper!
    @IBOutlet weak var imageWaterTank: UIImageView!
    
    @IBOutlet weak var nutritionsCircularBar: circularProgressBar!
    // Tab bar outlets next to circle progress
    @IBOutlet weak var carbsbar: HorizontalProgressBar!
    @IBOutlet weak var protiensBarView: HorizontalProgressBar!
    @IBOutlet weak var fatsBarView: HorizontalProgressBar!
    
    // Carbs tracking in grams
    @IBOutlet weak var carbsIntake: HorizontalProgressBar!
    @IBOutlet weak var protiensIntake: HorizontalProgressBar!
    @IBOutlet weak var fatsIntake: HorizontalProgressBar!
    
    @IBOutlet weak var lblDailyCarbs: UILabel!
    @IBOutlet weak var lblDailyProtiens: UILabel!
    @IBOutlet weak var lblDailyFats: UILabel!
    @IBOutlet weak var lblDailyCalories: UILabel!
    
    //Monthly and weekly progress bars
    @IBOutlet weak var weeklyCircle: UICircularProgressRing!
    @IBOutlet weak var monthlyCircle: UICircularProgressRing!
    
    //Labels for weight tracking
    @IBOutlet weak var lblCaloriesDepleted: UILabel!
    
    // labels for water intake
    @IBOutlet weak var lblWaterIntake: UILabel!
    @IBOutlet weak var lblIntakePercentage: UILabel!
    
    // labels for recent recepies
    @IBOutlet weak var recentMealsTableView: UITableView!
    @IBOutlet weak var tableViewControllerHeightConstraint: NSLayoutConstraint!
    
    // percentages from the calories consumed related labels
    @IBOutlet weak var lblCarbsConsumed: UILabel!
    @IBOutlet weak var lblFatConsumed: UILabel!
    @IBOutlet weak var lblProtienConsumed: UILabel!
    
    //Date related Label
    @IBOutlet weak var lblDateWaterTracking: UILabel!
    @IBOutlet weak var lblDateCaloriesDepletion: UILabel!
    
    // date picker control related
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var btnPreviousDate: UIButton!
    @IBOutlet weak var btnNextDate: UIButton!
    let formatter = DateFormatter()
    
    var selectedDate = ""
    var month = 0
    var week = 0
    
    // variables for weekly and monthly meals tracking
    var trackedMeals: [MealTracking] = []
    var selectedDateMeals: [MealTracking] = []
    
    var currentWeek = 0
    var currentMonth = 0
    
    // variables for calories calculation
    var caloriesNeed = 0.0
    
    var dailyCarbsNeeded = 0.0
    var dailyFatsNeeded = 0.0
    var dailyProtiensNeeded = 0.0
    
    var caloriesTaken = 0.0
    
    var dailyCarbsTaken = 0.0
    var dailyFatsTaken = 0.0
    var dailyProtiensTaken = 0.0
    
    var dailyFatsPercentage = 0.0
    var dailyCarbsPercentage = 0.0
    var dailyProtienPercentage = 0.0
    
    // percentages from the calories consumed
    var consumedFatsPercentage = 0.0
    var consumedCarbsPercentage = 0.0
    var consumedProtienPercentage = 0.0
    
    var caloriesFatsConsumed = 0.0
    var caloriesCarbsConsumed = 0.0
    var CaloriesProtienConsumed = 0.0
    
    // calories Depletion
    var dailyCaloriesDepleted = 0.0
    
    // water Tracking Related variables
    var waterTracking: [WaterTracking] = []
    var waterTrackingToday = false
    var dailyWaterIntake = 0.0
    
    var dailyWaterTracking = WaterTracking(ID: 0, quantity: 0, date: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        selectedDate = formatter.string(from: Date())
        
        cacheBreakfasts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initViews()
        
        registerTableView()
    }
    
    func initViews() {
        // get All the tracked meals saved in to the database
        registerNotifications()
        getMealTracking()
        
        // init all the data views
        initCaloriesView()
        initKetoPercentages()
        initMonthlyWeeklyTargets()
        initWaterTracking()
        
        addTapGestures()
        addObservers()
        
        addMaskedCorner(view: ketoView, size: 5.0)
        addMaskedCorner(view: targetsView, size: 5.0)
        addMaskedCorner(view: measurementsView, size: 5.0)
        addMaskedCorner(view: waterIntakeView, size: 5.0)
        
        recentMealsTableView.reloadData()
        tableViewControllerHeightConstraint.constant = 80.0 * CGFloat(selectedDateMeals.count)
    }
    
    func addObservers() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.refreshFeed(_:)), name: Notification.Name("caloriesDepleted"), object: nil)
    }
    
    @objc func refreshFeed(_ notification: NSNotification) {
       initViews()
    }
    
    
    func registerNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    if !UserDefaults.standard.bool(forKey: "notificationsAdded") {
                        self.scheduleAllNotifications()
                    }
                } else {
                    center.removeAllPendingNotificationRequests()
                }
            }
    }
    
    func scheduleAllNotifications() {
        UserDefaults.standard.set(true, forKey: "notificationsAdded")
        ScheduleWaterNotifications()
        scheduleNotification(title: "Breakfast Time", body: "Time to log Breakfast. Please take a moment and log breakfast.", type: 1)
        scheduleNotification(title: "Lunch Meal Time", body: "Time to log Lunch. Please take a moment and log Lunch.", type: 2)
        scheduleNotification(title: "Dinner Time", body: "Time to log Dinner. Please take a moment and log Dinner.", type: 3)
        scheduleNotification(title: "Log Calories", body: "How much calories did you depleted today?", type: 4)
        scheduleNotification(title: "Log Weight", body: "What is your weight this week? Kindly log your weight", type: 5)
    }
    
    func ScheduleWaterNotifications() {
        var uuids: [String] = []
        var dateComponents = DateComponents()
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Drink Water"
        content.body = "Take a glass of water please and log it in the App"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default

        for index in (7...22) {
            print(index)
            let uuid = UUID().uuidString
            uuids.append(uuid)
            
            dateComponents.hour = index
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
            center.add(request)
        }
        
        UserDefaults.standard.set("7", forKey: "waterStartHour")
        UserDefaults.standard.set("22", forKey: "waterEndHour")
        
        UserDefaults.standard.set("00", forKey: "waterStartMinute")
        UserDefaults.standard.set("00", forKey: "waterEndMinute")
        
        UserDefaults.standard.set(1, forKey: "waterStep")
        
        UserDefaults.standard.set(uuids, forKey: "waterUUIDs")
        UserDefaults.standard.set(true, forKey: "waterNotifications")
    }
    
    func scheduleNotification(title: String, body: String, type: Int) {
        // 1 for breakfast, 2 for lunch, 3 for dinner, 4 for calories Depletion, 5 for weight Log reminder
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        let uuid = UUID().uuidString
        
        if type == 1 {
            dateComponents.hour = 9
            dateComponents.minute = 00
            
            UserDefaults.standard.set(true, forKey: "breakfastNotifications")
            UserDefaults.standard.set(uuid, forKey: "breakfastUUID")
            
            UserDefaults.standard.set("9", forKey: "breakfastHour")
            UserDefaults.standard.set("00", forKey: "breakfastMinute")
            print(uuid)
        }
        
        if type == 2 {
            dateComponents.hour = 12
            dateComponents.minute = 00
            
            UserDefaults.standard.set(true, forKey: "lunchNotifications")
            UserDefaults.standard.set(uuid, forKey: "lunchUUID")
            
            UserDefaults.standard.set("12", forKey: "lunchHour")
            UserDefaults.standard.set("00", forKey: "lunchMinute")
        }
        
        if type == 3 {
            dateComponents.hour = 18
            dateComponents.minute = 00
            
            UserDefaults.standard.set(true, forKey: "dinnerNotifications")
            UserDefaults.standard.set(uuid, forKey: "dinnerUUID")
            
            UserDefaults.standard.set("18", forKey: "dinnerHour")
            UserDefaults.standard.set("00", forKey: "dinnerMinute")
        }
        
        if type == 4 {
            dateComponents.hour = 21
            dateComponents.minute = 00
            
            UserDefaults.standard.set(true, forKey: "caloriesNotifications")
            UserDefaults.standard.set(uuid, forKey: "caloriesUUID")
        }
        
        if type == 5 {
            dateComponents.hour = 12
            dateComponents.minute = 00
            
            dateComponents.weekday = 0
            
            UserDefaults.standard.set(true, forKey: "weightNotifications")
            UserDefaults.standard.set(uuid, forKey: "weightUUID")
            
            UserDefaults.standard.set("12", forKey: "weightHour")
            UserDefaults.standard.set("00", forKey: "weightMinute")
            
            UserDefaults.standard.set(0, forKey: "weightWeekday")
        }
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        center.add(request)
        
    }
    
    func registerTableView() {
        let nib = UINib(nibName: "CustomMealTableViewCell", bundle: nil)
        recentMealsTableView.register(nib, forCellReuseIdentifier: "CustomMealTableViewCell")
        recentMealsTableView.delegate = self
        recentMealsTableView.dataSource = self
    }
    
    func initWaterTracking() {
        self.dailyWaterIntake = 0.0
        waterTrackingToday = false
        self.waterTracking = DatabaseManager.getInstance().getWaterTracking()
        
        for dailyTracking in self.waterTracking {
            if (dailyTracking.date == self.selectedDate) {
                waterTrackingToday = true
                self.dailyWaterIntake = Double(dailyTracking.quantity)
            }
        }
        
        lblWaterIntake.text = "\(Int(dailyWaterIntake)) ml"
        let percentage = Int((dailyWaterIntake / 3500) * 100)
        lblIntakePercentage.text = "\(percentage)"
        waterIntakeStepper.value = dailyWaterIntake
        
        setWaterTankImage()
    }
    
    func initCaloriesView() {
        initDatePickerView()
        getCaloriesDepletion()
        getUserPreferences()
        calculateDailyCalories()
        setDailyCaloriesDetails()
    }
    
    func getUserPreferences() {
        let goal = UserDefaults.standard.string(forKey: "userGoal")
        let gender = UserDefaults.standard.string(forKey: "gender")
        let bornYear = UserDefaults.standard.integer(forKey: "bornYear")
        let bornMonth = UserDefaults.standard.integer(forKey: "bornMonth")
        let height = UserDefaults.standard.double(forKey: "height")
        let currentWeight = UserDefaults.standard.double(forKey: "currentWeight")
        let targetWeight = UserDefaults.standard.double(forKey: "targetWeight")
        let activityLevel = UserDefaults.standard.string(forKey: "activityLevel")
        let duration = UserDefaults.standard.float(forKey: "weeks")
        
        var age = self.calculateAge(bornMonth: bornMonth,bornYear: bornYear)
        
        if gender == "Male" {
            if goal == "EatAndTrain" {
                caloriesNeed = 66.5 + (13.8 * currentWeight) + (5.0 * height) - (6.8 * Double(age))
            } else {
                caloriesNeed = 66.5 + (13.8 * targetWeight) + (5.0 * height) - (6.8 * Double(age))
            }
            
        } else if gender == "Female" {
            if goal == "EatAndTrain" {
                caloriesNeed = 655.1 + (9.6 * currentWeight) + (1.9 * height) - (4.7 * Double(age))
            } else {
                caloriesNeed = 655.1 + (9.6 * targetWeight) + (1.9 * height) - (4.7 * Double(age))
            }
        }
        
        if activityLevel == "Moderate" {
            caloriesNeed = caloriesNeed * 1.2
        } else if activityLevel == "High" {
            caloriesNeed = caloriesNeed * 1.5
        }
        
        caloriesNeed = caloriesNeed - dailyCaloriesDepleted
        
        dailyCarbsNeeded = (caloriesNeed * 0.05) / 4
        dailyProtiensNeeded = (caloriesNeed * 0.25) / 4
        dailyFatsNeeded = (caloriesNeed * 0.70) / 9
    }
    
    func calculateAge(bornMonth: Int, bornYear: Int) -> Int {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        let currentYear =  Int(components.year!)
        let currentMonth =  Int(components.month!)
        print(currentYear)
        
        var age = (currentYear - bornYear) - 1
        
        if bornMonth+1 < currentMonth {
            age = age + 1
        }
        
        return age
    }
    
    func calculateDailyCalories() {
        selectedDateMeals = []

        caloriesTaken = 0.0
        dailyCarbsTaken = 0.0
        dailyProtiensTaken = 0.0
        dailyFatsTaken = 0.0
        
        caloriesFatsConsumed = 0.0
        caloriesCarbsConsumed = 0.0
        CaloriesProtienConsumed = 0.0
        
        consumedFatsPercentage = 0.0
        consumedCarbsPercentage = 0.0
        consumedProtienPercentage = 0.0
        
        for meal in trackedMeals {
            if meal.date == selectedDate {
                selectedDateMeals.append(meal)
                
                caloriesTaken = caloriesTaken + Double((meal.calories * meal.servings))
                dailyCarbsTaken = dailyCarbsTaken + Double((meal.carbs * meal.servings))
                dailyProtiensTaken = dailyProtiensTaken + Double((meal.protien * meal.servings))
                dailyFatsTaken = dailyFatsTaken + Double((meal.fats * meal.servings))
            }
        }
        
        if caloriesTaken > 0.0 {
            caloriesFatsConsumed = dailyFatsTaken * 9
            caloriesCarbsConsumed = dailyCarbsTaken * 4
            CaloriesProtienConsumed = dailyProtiensTaken * 4
            
            consumedFatsPercentage = caloriesFatsConsumed / caloriesTaken
            consumedCarbsPercentage = caloriesCarbsConsumed / caloriesTaken
            consumedProtienPercentage = CaloriesProtienConsumed / caloriesTaken
        }
        
        dailyFatsPercentage = (dailyFatsTaken / dailyFatsNeeded) * 100
        dailyCarbsPercentage = (dailyCarbsTaken / dailyCarbsNeeded) * 100
        dailyProtienPercentage = (dailyProtiensTaken / dailyProtiensNeeded) * 100
    }
    
    func setDailyCaloriesDetails() {
        carbsIntake.progress = CGFloat(dailyCarbsPercentage / 100.0)
        protiensIntake.progress = CGFloat(dailyProtienPercentage / 100.0)
        fatsIntake.progress = CGFloat(dailyFatsPercentage / 100.0)
        
        if dailyFatsTaken >= dailyFatsNeeded {
            lblDailyFats.text = "\(round(dailyFatsNeeded * 100)/100)g / \(round(dailyFatsNeeded * 100)/100)g"
        } else {
            lblDailyFats.text = "\(round(dailyFatsTaken * 100)/100)g / \(round(dailyFatsNeeded * 100)/100)g"
        }
        
        if dailyCarbsTaken >= dailyCarbsNeeded {
            lblDailyCarbs.text = "\(round(dailyCarbsNeeded * 100)/100)g / \(round(dailyCarbsNeeded * 100)/100)g"
        } else {
            lblDailyCarbs.text = "\(round(dailyCarbsTaken * 100)/100)g / \(round(dailyCarbsNeeded * 100)/100)g"
        }
        
        if dailyProtiensTaken >= dailyProtiensNeeded {
            lblDailyProtiens.text = "\(round(dailyProtiensNeeded * 100)/100)g / \(round(dailyProtiensNeeded * 100)/100)g"
        } else {
            lblDailyProtiens.text = "\(round(dailyProtiensTaken * 100)/100)g / \(round(dailyProtiensNeeded * 100)/100)g"
        }
        
        if caloriesTaken >= caloriesNeed {
            lblDailyCalories.text = "\(Int(caloriesNeed))/\(Int(caloriesNeed))"
        } else {
            lblDailyCalories.text = "\(Int(caloriesTaken))/\(Int(caloriesNeed))"
        }
    }
    
    func initDatePickerView() {
        setDateLabel()
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
    
     
    func initKetoPercentages() {
        consumedFatsPercentage = 1.0 - (consumedCarbsPercentage + consumedProtienPercentage)
        
        if consumedFatsPercentage == 1.0 {
            consumedFatsPercentage = 0.0
        }
        
        carbsbar.progress = CGFloat(consumedCarbsPercentage)
        protiensBarView.progress = CGFloat(consumedProtienPercentage)
        fatsBarView.progress = CGFloat(consumedFatsPercentage)
        
        nutritionsCircularBar.carbsPercent = CGFloat(consumedCarbsPercentage)
        nutritionsCircularBar.protienPercent = CGFloat(consumedProtienPercentage)
        nutritionsCircularBar.fatPercent = CGFloat(consumedFatsPercentage)
        
        
        lblCarbsConsumed.text = "\(round(consumedCarbsPercentage * 1000)/10)% "
        lblFatConsumed.text = "\(round(consumedFatsPercentage * 1000)/10)% "
        lblProtienConsumed.text = "\(round(consumedProtienPercentage * 1000)/10)% "
    }
    
    func initMonthlyWeeklyTargets() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear, .month , .weekOfMonth], from: Date())
        
        currentMonth = components.month ?? 0
        currentWeek = components.weekOfYear ?? 0
        
        
        let weeklyTarget = UserDefaults.standard.string(forKey: "weeklyTarget")
        let monthlyTarget = UserDefaults.standard.string(forKey: "monthlyTarget")
        
        if (weeklyTarget == nil) {
            weeklyCircle.value = 0.0
        } else {
            let count = getWeeklyMealsCount()
            
            let target: CGFloat = CGFloat(NumberFormatter().number(from: weeklyTarget!)!)
            let percentage:CGFloat = (count / target) * CGFloat(100)
            weeklyCircle.value = percentage
        }
        
        if (monthlyTarget == nil) {
            monthlyCircle.value = CGFloat(0.0)
        } else {
            let count = getMonthlyMealsCount()
            
            var target: CGFloat = CGFloat(NumberFormatter().number(from: monthlyTarget!)!)
            let percentage = (count / target) * CGFloat(100)
            monthlyCircle.value = CGFloat(percentage)
        }
    }
    
    func getMealTracking() {
        self.trackedMeals = DatabaseManager.getInstance().getMealTracking()
    }
    
    func getCaloriesDepletion() {
        self.dailyCaloriesDepleted = 0.0
        var caloriesDepleted: [CaloriesDepleted] = DatabaseManager.getInstance().getDepletedCalories()
        
        for dailyDepletion in caloriesDepleted {
            if (dailyDepletion.date == self.selectedDate) {
                self.dailyCaloriesDepleted = Double(dailyDepletion.calories)
            }
        }
        
        lblCaloriesDepleted.text = "\(self.dailyCaloriesDepleted) kcal"
    }
    
    func getMonthlyMealsCount() -> CGFloat {
        var meals = 0
        for meal in self.trackedMeals {
            if (meal.month == currentMonth) {
                meals = meals + 1
            }
        }
        
        return CGFloat(meals)
    }
    
    func getWeeklyMealsCount() -> CGFloat {
        var meals = 0
        for meal in self.trackedMeals {
            if (meal.week == currentWeek) {
                meals = meals + 1
            }
        }
        
        return CGFloat(meals)
    }
    
    func setDateLabel() {
        lblSelectedDate.text = selectedDate
        lblDateWaterTracking.text = selectedDate
        lblDateCaloriesDepletion.text = selectedDate
    }
    
    func addTapGestures() {
        let nextGesture = UITapGestureRecognizer(target: self, action: #selector(nextButtonTapped(_:)))
        nextGesture.numberOfTapsRequired = 1
        nextGesture.numberOfTouchesRequired = 1
        
        iconNext.addGestureRecognizer(nextGesture);
        iconNext.isUserInteractionEnabled = true
        
        let targetsGesture = UITapGestureRecognizer(target: self, action: #selector(targetsnextButtonTapped(_:)))
        targetsGesture.numberOfTapsRequired = 1
        targetsGesture.numberOfTouchesRequired = 1
        
        targetsNext.addGestureRecognizer(targetsGesture);
        targetsNext.isUserInteractionEnabled = true
        
        let weightGesture = UITapGestureRecognizer(target: self, action: #selector(weightNextTapped(_:)))
        weightGesture.numberOfTapsRequired = 1
        weightGesture.numberOfTouchesRequired = 1
        
        measurementsNext.addGestureRecognizer(weightGesture);
        measurementsNext.isUserInteractionEnabled = true
    }
    
    func addMaskedCorner(view: UIView, size: CGFloat) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.1
        
        view.layer.cornerRadius = size
    }
    
    func navigateToKeto() {
        let vc = storyboard?.instantiateViewController(identifier: "KetoViewController") as! KetoViewController
        vc.setDetails(selectedDateMeals: selectedDateMeals, trackedMeals: trackedMeals, selectedDate: selectedDate, caloriesNeed: caloriesNeed, caloriesTaken: caloriesTaken, dailyCarbsNeeded: dailyCarbsNeeded, dailyFatsNeeded: dailyFatsNeeded, dailyProtiensNeeded: dailyProtiensNeeded, dailyCarbsTaken: dailyCarbsTaken, dailyFatsTaken: dailyFatsTaken, dailyProtiensTaken: dailyProtiensTaken, dailyFatsPercentage: dailyFatsPercentage, dailyCarbsPercentage: dailyCarbsPercentage, dailyProtienPercentage: dailyProtienPercentage)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToMealTracking() {
        let vc = storyboard?.instantiateViewController(identifier: "MealTrackingViewController") as! MealTrackingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToCaloriesDepletion() {
        //let vc = storyboard?.instantiateViewController(identifier: "LogWeightViewController") as! LogWeightViewController
        let vc = storyboard?.instantiateViewController(identifier: "CaloriesDepletedViewController") as! CaloriesDepletedViewController
        vc.modalPresentationStyle = .popover

        present(vc, animated: true)
    }
    
    // Keto Details Button Events
    @objc func nextButtonTapped(_ gesture: UITapGestureRecognizer) {
        navigateToKeto()
    }
    
    @IBAction func ketoDetailsClicked(_ sender: Any) {
        navigateToKeto()
    }
    
    // Daily and Monthly Targets Button Events
    @objc func targetsnextButtonTapped(_ gesture: UITapGestureRecognizer) {
        navigateToMealTracking()
    }
    
    @IBAction func TargetsClicked(_ sender: Any) {
        navigateToMealTracking()
    }
    
    // Weight Tracking Button Events
    @objc func weightNextTapped(_ gesture: UITapGestureRecognizer) {
        navigateToCaloriesDepletion()
    }
    
    @IBAction func logCaloriesDepleted(_ sender: Any) {
        navigateToCaloriesDepletion()
    }
    
    @IBAction func changeWaterIntake(_ sender: UIStepper) {
        if dailyWaterIntake < Double(sender.value) {
            // water glass added
            Analytics.logEvent("water_glass_added", parameters: ["date": self.selectedDate])
        } else {
            // water glass removed
            Analytics.logEvent("water_glass_removed", parameters: ["date": self.selectedDate])
        }
        
        lblWaterIntake.text = "\(sender.value) ml"
        dailyWaterIntake = Double(sender.value)
        let percentage = Int((sender.value / 3500) * 100)
        lblIntakePercentage.text = "\(percentage)"
        setWaterTankImage()
        
        self.dailyWaterTracking = WaterTracking(ID: 0, quantity: Int(sender.value) , date: self.selectedDate)
        var isSave = false
        
        if (!waterTrackingToday) {
            isSave = DatabaseManager.getInstance().trackWater(self.dailyWaterTracking)
        } else {
            isSave = DatabaseManager.getInstance().updateWater(self.dailyWaterTracking)
        }
    }
    
    func setWaterTankImage() {
        var imageIndex = (Int(dailyWaterIntake) / 250)
        
        var image : UIImage = UIImage(named:"waterTank\(imageIndex)")!
        imageWaterTank.image = image
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recentMealsTableView.dequeueReusableCell(withIdentifier: "CustomMealTableViewCell", for: indexPath) as! CustomMealTableViewCell

        cell.configureCellForRecentMeals(recentMeal: selectedDateMeals[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal: MealTracking = selectedDateMeals[indexPath.row]
        let mealId: String = meal.mealId
        var recepieType = ""
        
        if (mealId.count > 3) {
            let index = mealId.index(mealId.startIndex, offsetBy: 2)
            let s1 = mealId[..<index]
            if s1 == "br" {
                recepieType = "breakfast"
            } else if s1 == "lu" {
                recepieType = "lunch"
            } else if s1 == "dn" {
                recepieType = "dinner"
            }
        } else {
            recepieType = "custom"
        }
        
        
        if recepieType == "custom" {
            let vc = storyboard?.instantiateViewController(identifier: "CustomMealsDetailsViewController") as! CustomMealsDetailsViewController
            let customMeal = CustomMeal(mealId: Int(meal.mealId) ?? 0, mealName: meal.mealName, calories: meal.calories, fats: meal.fats, protien: meal.protien, carbs: meal.carbs )
            vc.setData(mealDetails: customMeal)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(identifier: "RecepieDetailsViewController") as! RecepieDetailsViewController
            vc.setData(recepieID: mealId, recepieType: recepieType)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDateMeals.count
    }
    
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let isDelete = DatabaseManager.getInstance().deleteMeal(selectedDateMeals[indexPath.row])
            
            if isDelete {
                let formatter1 = DateFormatter()
                formatter1.dateStyle = .full
                formatter1.timeStyle = .full
                Analytics.logEvent("meal_deleted_home", parameters: ["date": formatter1.string(from: Date())])
                
                initViews()
            }
        }
    }
    
    // caching Recepies for food tab
    private func getRecepies(from url: String, type: String) {
        print("\(url)\(type)")
        let req = URLSession.shared

        URLSession.shared.dataTask(with: URL(string: "\(url)\(type)")!, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("something occured")
                return
            }
            
            var result: Recepie?
            do {
                result = try JSONDecoder().decode(Recepie.self, from: data)
            } catch {
                print("Failed to convert \(error.localizedDescription)")
            }
            
            guard let recepies = result else {
                return
            }
                        
            UserDefaults.standard.set(try? PropertyListEncoder().encode(recepies), forKey:type)
            if type == "breakfast" {
                self.cacheLunch()
            } else if type == "lunch" {
                self.cacheDinner()
            }
            
        }).resume()
    }
    
    func cacheBreakfasts() {
        getRecepies(from: baseUrl, type: "breakfast");
    }
    
    func cacheLunch() {
        getRecepies(from: baseUrl, type: "lunch");
    }
    
    func cacheDinner() {
        getRecepies(from: baseUrl, type: "dinner");
    }
}
