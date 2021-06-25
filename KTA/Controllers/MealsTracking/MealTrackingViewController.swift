//
//  MealTrackingViewController.swift
//  KTA
//
//  Created by qadeem on 19/02/2021.
//

import UIKit
import UICircularProgressRing

class MealTrackingViewController: UIViewController {
    @IBOutlet weak var lblWeeklyGoals: UILabel!
    @IBOutlet weak var lblMonthlyGoals: UILabel!
    
    @IBOutlet weak var weeklyProgressRing: UICircularProgressRing!
    @IBOutlet weak var monthlyProgressRing: UICircularProgressRing!
    
    var trackedMeals: [MealTracking] = []
    
    var currentWeek = 0
    var currentMonth = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initViews()
    }
    
    func initViews() {
        getMealTracking()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear, .month , .weekOfMonth], from: Date())
        
        currentMonth = components.month ?? 0
        currentWeek = components.weekOfYear ?? 0
        
        
        let weeklyTarget = UserDefaults.standard.string(forKey: "weeklyTarget")
        let monthlyTarget = UserDefaults.standard.string(forKey: "monthlyTarget")
        
        if (weeklyTarget == nil) {
            lblWeeklyGoals.text = "-"
            weeklyProgressRing.value = 0.0
        } else {
            let count = getWeeklyMealsCount()
            
            let target: CGFloat = CGFloat(NumberFormatter().number(from: weeklyTarget!)!)
            let percentage:CGFloat = (count / target) * CGFloat(100)
            weeklyProgressRing.value = percentage
            
            lblWeeklyGoals.text = "\(Int(count)) / \(String(describing: weeklyTarget!))"
        }
        
        if (monthlyTarget == nil) {
            lblMonthlyGoals.text = "-"
            monthlyProgressRing.value = 0.0
        } else {
            let count = getMonthlyMealsCount()
            
            var target: CGFloat = CGFloat(NumberFormatter().number(from: monthlyTarget!)!)
            let percentage = (count / target) * CGFloat(100)
            monthlyProgressRing.value = CGFloat(percentage)
            
            lblMonthlyGoals.text = "\(Int(count)) / \(String(describing: monthlyTarget!))"
        }
    }
    
    func getMealTracking() {
        self.trackedMeals = DatabaseManager.getInstance().getMealTracking()
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
    
    @IBAction func navigateToGoals(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SetMealGoalsViewController") as! SetMealGoalsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
