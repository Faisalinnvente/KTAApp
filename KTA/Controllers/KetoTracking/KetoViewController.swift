//
//  KetoViewController.swift
//  KTA
//
//  Created by qadeem on 16/02/2021.
//

import UIKit
import Charts
import TinyConstraints
import UICircularProgressRing

class KetoViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var caloriesView: UIView!
    @IBOutlet weak var targetsView: UIView!
    @IBOutlet weak var macroNutrientsView: UIView!
    @IBOutlet weak var waterIntakeView: UIView!
    @IBOutlet weak var weightView: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var weightChartView: LineChartView!
    @IBOutlet weak var caloriesChartView: CombinedChartView!
    @IBOutlet weak var waterChart: CombinedChartView!
    
    @IBOutlet weak var carbsbar: HorizontalProgressBar!
    @IBOutlet weak var protiensBarView: HorizontalProgressBar!
    @IBOutlet weak var fatsBarView: HorizontalProgressBar!
    
    @IBOutlet weak var lblCarbsIntake: UILabel!
    @IBOutlet weak var lblProtienIntake: UILabel!
    @IBOutlet weak var lblFatIntake: UILabel!
    
    // Date Label
    @IBOutlet weak var lblDateCalsView: UILabel!
    @IBOutlet weak var lblDateWater: UILabel!
    @IBOutlet weak var lblDateWeight: UILabel!
    
    // calories related labeld
    @IBOutlet weak var lblCaloriesNeeded: UILabel!
    @IBOutlet weak var lblCaloriesDetails: UILabel!
    
    //circular progress bars
    @IBOutlet weak var weeklyTargetsProgress: UICircularProgressRing!
    @IBOutlet weak var monthlyTargetsProgress: UICircularProgressRing!
    @IBOutlet weak var caloriesPercentageProgress: UICircularProgressRing!
    
    // variables for calories calculation
    var caloriesNeed = 0.0
    var caloriesTaken = 0.0
    var caloriesPercentage = 0.0
    
    // Carbs related variables
    var dailyCarbsNeeded = 0.0
    var dailyFatsNeeded = 0.0
    var dailyProtiensNeeded = 0.0
    
    var dailyCarbsTaken = 0.0
    var dailyFatsTaken = 0.0
    var dailyProtiensTaken = 0.0
    
    var dailyFatsPercentage = 0.0
    var dailyCarbsPercentage = 0.0
    var dailyProtienPercentage = 0.0
    
    //Labels for calories depletion
    @IBOutlet weak var lblCaloriesDepleted: UILabel!
    @IBOutlet weak var caloriesDepletionView: UIView!
    @IBOutlet weak var caloriesDepNext: UIImageView!
    @IBOutlet weak var lblCaloriesDep: UILabel!
    
    //Labels for weight tracking
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var measurementsView: UIView!
    @IBOutlet weak var measurementsNext: UIImageView!
    @IBOutlet weak var lblWeightTrackDate: UILabel!
    
    
    // calories Depletion
    var dailyCaloriesDepleted = 0.0
    
    // weight Tracking Depletion
    var dailyWeight = 0.0
    
    // Date related variables
    let formatter = DateFormatter()
    let reverseFormatter = DateFormatter()
    
    var selectedDate = ""
    var month = 0
    var week = 0
    
    // variables for weekly and monthly meals tracking
    var selectedDateMeals: [MealTracking] = []
    var trackedMeals: [MealTracking] = []
    
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "July", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    var currentWeek = 0
    var currentMonth = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        reverseFormatter.dateStyle = .full
        reverseFormatter.timeStyle = .full
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers();
        initViews()
    }
    
    func setDetails(selectedDateMeals: [MealTracking],trackedMeals: [MealTracking], selectedDate: String, caloriesNeed: Double, caloriesTaken: Double, dailyCarbsNeeded: Double, dailyFatsNeeded: Double, dailyProtiensNeeded: Double, dailyCarbsTaken: Double, dailyFatsTaken: Double, dailyProtiensTaken: Double, dailyFatsPercentage: Double, dailyCarbsPercentage: Double, dailyProtienPercentage: Double) {
        
        self.caloriesNeed = caloriesNeed
        self.caloriesTaken = caloriesTaken
        self.caloriesPercentage = (caloriesTaken/caloriesNeed) * 100
        
        // Carbs related variables
        self.dailyCarbsNeeded = dailyCarbsNeeded
        self.dailyFatsNeeded = dailyFatsNeeded
        self.dailyProtiensNeeded = dailyProtiensNeeded
        
        self.dailyCarbsTaken = dailyCarbsTaken
        self.dailyFatsTaken = dailyFatsTaken
        self.dailyProtiensTaken = dailyProtiensTaken
        
        self.dailyFatsPercentage = dailyFatsPercentage
        self.dailyCarbsPercentage = dailyCarbsPercentage
        self.dailyProtienPercentage = dailyProtienPercentage
        
        // Date related variables
        self.selectedDate = selectedDate
        
        // variables for weekly and monthly meals tracking
        self.selectedDateMeals = selectedDateMeals
        self.trackedMeals = trackedMeals
        
        self.currentWeek = 0
        self.currentMonth = 0
    }
    
    func initViews() {
        navigationController?.setNavigationBarHidden(true, animated: true)
       
        initCaloriesChart()
        initWaterIntakeChart()
        
        initWeightChart()
        
        setCaloriesData()
        setDailyCaloriesDetails()
        
        initMonthlyWeeklyTargets()
        setDatesLabels()
        
        getCaloriesDepletion()
        getWeightTracking()
        
        addTapGestures()
        
        addMaskedCorner(view: caloriesView, size: 5.0)
        addMaskedCorner(view: targetsView, size: 5.0)
        addMaskedCorner(view: macroNutrientsView, size: 5.0)
        addMaskedCorner(view: waterIntakeView, size: 5.0)
        addMaskedCorner(view: weightView, size: 5.0)
        
    }
    
    func addObservers() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.refreshFeed(_:)), name: Notification.Name("caloriesDepleted"), object: nil)
        nc.addObserver(self, selector: #selector(self.refreshFeed(_:)), name: Notification.Name("weightLogged"), object: nil)
    }
    
    @objc func refreshFeed(_ notification: NSNotification) {
       initViews()
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
    
    func getWeightTracking() {
        self.dailyWeight = 0.0
        var weightTracking: [WeightTracking] = DatabaseManager.getInstance().getWeightTracking()
        
        for weight in weightTracking {
            if (weight.date == self.selectedDate) {
                self.dailyWeight = Double(weight.weight)
            }
        }
        
        if dailyWeight == 0.0 {
            lblWeight.text = "-"
        } else {
            lblWeight.text = "\(self.dailyWeight) LBs"
        }
    }
    
    func navigateToCaloriesDepletion() {
        let vc = storyboard?.instantiateViewController(identifier: "CaloriesDepletedViewController") as! CaloriesDepletedViewController
        vc.modalPresentationStyle = .popover

        present(vc, animated: true)
    }
    
    func navigateToWeightTracking() {
        let vc = storyboard?.instantiateViewController(identifier: "LogWeightViewController") as! LogWeightViewController
        vc.modalPresentationStyle = .popover

        present(vc, animated: true)
    }
    
    func addTapGestures() {
        let weightGesture = UITapGestureRecognizer(target: self, action: #selector(weightNextTapped(_:)))
        weightGesture.numberOfTapsRequired = 1
        weightGesture.numberOfTouchesRequired = 1
        
        measurementsNext.addGestureRecognizer(weightGesture);
        measurementsNext.isUserInteractionEnabled = true
        
        let depletionGesture = UITapGestureRecognizer(target: self, action: #selector(caloriesNextTapped(_:)))
        depletionGesture.numberOfTapsRequired = 1
        depletionGesture.numberOfTouchesRequired = 1
        
        caloriesDepNext.addGestureRecognizer(depletionGesture);
        caloriesDepNext.isUserInteractionEnabled = true
    }
    
    // Weight Tracking Button Events
    @objc func weightNextTapped(_ gesture: UITapGestureRecognizer) {
        navigateToWeightTracking()
    }
    
    // Weight Tracking Button Events
    @objc func caloriesNextTapped(_ gesture: UITapGestureRecognizer) {
        navigateToCaloriesDepletion()
    }
    
    func setDatesLabels() {
        lblDateCalsView.text = "\(selectedDate)"
        lblDateWater.text = "\(selectedDate)"
        lblDateWeight.text = "\(selectedDate)"
        
        lblWeightTrackDate.text = "\(selectedDate)"
        lblCaloriesDep.text = "\(selectedDate)"
    }
    
    func setDailyCaloriesDetails() {
        carbsbar.progress = CGFloat(dailyCarbsPercentage / 100.0)
        protiensBarView.progress = CGFloat(dailyProtienPercentage / 100.0)
        fatsBarView.progress = CGFloat(dailyFatsPercentage / 100.0)
        
        caloriesPercentageProgress.value = CGFloat(caloriesPercentage)
        
        lblCarbsIntake.text = "\(round(dailyFatsTaken * 100)/100)g / \(round(dailyFatsNeeded * 100)/100)g"
        lblProtienIntake.text = "\(round(dailyCarbsTaken * 100)/100)g / \(round(dailyCarbsNeeded * 100)/100)g"
        lblFatIntake.text = "\(round(dailyProtiensTaken * 100)/100)g / \(round(dailyProtiensNeeded * 100)/100)g"
        
        lblCaloriesNeeded.text = "\(Int(caloriesTaken)) kcal"
        lblCaloriesDetails.text = "\(round(caloriesPercentage * 100)/100)% of \(Int(caloriesNeed)) kcal daily goal"
    }
    
    func initMonthlyWeeklyTargets() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear, .month , .weekOfMonth], from: Date())
        
        currentMonth = components.month ?? 0
        currentWeek = components.weekOfYear ?? 0
        
        
        let weeklyTarget = UserDefaults.standard.string(forKey: "weeklyTarget")
        let monthlyTarget = UserDefaults.standard.string(forKey: "monthlyTarget")
        
        if (weeklyTarget == nil) {
            weeklyTargetsProgress.value = 0.0
        } else {
            let count = getWeeklyMealsCount()
            
            let target: CGFloat = CGFloat(NumberFormatter().number(from: weeklyTarget!)!)
            let percentage:CGFloat = (count / target) * CGFloat(100)
            weeklyTargetsProgress.value = percentage
        }
        
        if (monthlyTarget == nil) {
            monthlyTargetsProgress.value = CGFloat(0.0)
        } else {
            let count = getMonthlyMealsCount()
            
            var target: CGFloat = CGFloat(NumberFormatter().number(from: monthlyTarget!)!)
            let percentage = (count / target) * CGFloat(100)
            monthlyTargetsProgress.value = CGFloat(percentage)
        }
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
    
    @IBAction func logCaloriesDepleted(_ sender: Any) {
        navigateToCaloriesDepletion()
    }
    
    @IBAction func logWeightClicked(_ sender: Any) {
        navigateToWeightTracking()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func initWaterIntakeChart() {
        waterChart.delegate = self
                
        //waterChart.drawBarShadowEnabled = false
        //waterChart.drawValueAboveBarEnabled = false
        waterChart.maxVisibleCount = 60
        waterChart.leftAxis.enabled = false
        
        waterChart.leftAxis.enabled = false
        let yAxis = waterChart.rightAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        
        waterChart.xAxis.labelPosition = .bottom
        waterChart.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        waterChart.xAxis.setLabelCount(6, force: false)
        waterChart.animate(xAxisDuration: 1.0)
                
        setWaterIntakeData()
    }
    
    func setWaterIntakeData() {
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        date = cal.date(byAdding: .day, value: -6, to: date)!
        var dates = [String]()
        var days = [Int]()
        var waterIntake = [Double]()
        var targetWaterIntake = [Double]()
        
        var curMonth = 0
        var curYear = ""
        
        for i in 1 ... 7 {
            dates.append(formatter.string(from: date))
            let day = cal.component(.day, from: date)
            curMonth = cal.component(.month, from: date)
            curYear = String(cal.component(.year, from: date))

            days.append(day)

            var dailyIntake = 0
            let waterTracking: [WaterTracking] = DatabaseManager.getInstance().getWaterTracking()
            
            for dailyTrack in waterTracking {
                if dailyTrack.date == formatter.string(from: date) {
                    dailyIntake = dailyTrack.quantity
                }
            }
            
            waterIntake.append(Double(dailyIntake))
            targetWaterIntake.append(Double(3500))
            
            date = cal.date(byAdding: .day, value: 1, to: date)!
        }

        var dataEntries: [BarChartDataEntry] = []
        var targetEntries: [BarChartDataEntry] = []
        
        for i in 0..<dates.count {
            let dataEntry = BarChartDataEntry(x: Double(days[i]), y: waterIntake[i])
            let targetEntry = BarChartDataEntry(x: Double(days[i]), y: targetWaterIntake[i])
            
            dataEntries.append(dataEntry)
            targetEntries.append(targetEntry)
        }
         
        
        var set1: BarChartDataSet! = nil
        set1 = BarChartDataSet(entries: dataEntries, label: "Water Tracking for \(months[curMonth-1]) - \(curYear)")
        //set1.colors = ChartColorTemplates.pastel()
        set1.setColor(UIColor(named: "Primary")!)
        set1.drawValuesEnabled = false
          
        
        var set2: LineChartDataSet! = nil
        set2 = LineChartDataSet(entries: targetEntries, label: "Target Water Intake")
        set2.setColor(UIColor.link)
        set2.drawCirclesEnabled = false
        set2.lineWidth = 3.0
        set2.mode = .horizontalBezier
        
        let dataSets: [LineChartDataSet] = [set2]
        let lineData = LineChartData(dataSets: dataSets)
        lineData.setDrawValues(false)
        
        let bardata = BarChartData(dataSet: set1)
        bardata.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        bardata.barWidth = 0.2
        
        let data = CombinedChartData()
        data.barData = bardata //BarChartData(dataSet: set1)
        data.lineData = LineChartData(dataSets: dataSets)
        
        waterChart.data = data
        waterChart.noDataText = "You need to provide data for the chart."
    }
    
    func initCaloriesChart() {
        caloriesChartView.delegate = self
                
        //caloriesChartView.drawBarShadowEnabled = false
        //caloriesChartView.drawValueAboveBarEnabled = false
        caloriesChartView.maxVisibleCount = 60
        caloriesChartView.leftAxis.enabled = false
        
        caloriesChartView.leftAxis.enabled = false
        let yAxis = caloriesChartView.rightAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        
        caloriesChartView.xAxis.labelPosition = .bottom
        caloriesChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        caloriesChartView.xAxis.setLabelCount(6, force: false)
        caloriesChartView.animate(xAxisDuration: 1.0)
                
        setCaloriesData()
    }
    
    func setCaloriesData() {
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        date = cal.date(byAdding: .day, value: -6, to: date)!
        var dates = [String]()
        var days = [Int]()
        var calories = [Double]()
        var targetCalories = [Double]()
        
        var curMonth = 0
        var curYear = ""
        
        for i in 1 ... 7 {
            dates.append(formatter.string(from: date))
            let day = cal.component(.day, from: date)
            curMonth = cal.component(.month, from: date)
            curYear = String(cal.component(.year, from: date))

            days.append(day)

            var dailyCals = 0
            let trackedMeals: [MealTracking] = DatabaseManager.getInstance().getMealTracking()
            
            for meal in trackedMeals {
                if meal.date == formatter.string(from: date) {
                    dailyCals = dailyCals + meal.calories
                }
            }
            
            targetCalories.append(self.caloriesNeed)
            calories.append(Double(dailyCals))
            date = cal.date(byAdding: .day, value: 1, to: date)!
        }

        var dataEntries: [BarChartDataEntry] = []
        var targetEntries: [BarChartDataEntry] = []
        
        for i in 0..<dates.count {
            let dataEntry = BarChartDataEntry(x: Double(days[i]), y: calories[i])
            let targetEntry = BarChartDataEntry(x: Double(days[i]), y: targetCalories[i])
            
            dataEntries.append(dataEntry)
            targetEntries.append(targetEntry)
        }
        
        var set1: BarChartDataSet! = nil
        set1 = BarChartDataSet(entries: dataEntries, label: "Calories Overview for \(months[curMonth-1]) - \(curYear)")
        set1.setColor(UIColor(named: "Primary")!)
        set1.drawValuesEnabled = false
        
        var set2: LineChartDataSet! = nil
        set2 = LineChartDataSet(entries: targetEntries, label: "Target Calories Intake")
        set2.setColor(UIColor.link)
        set2.drawCirclesEnabled = false
        set2.lineWidth = 3.0
        set2.mode = .horizontalBezier
        
        let dataSets: [LineChartDataSet] = [set2]
        let lineData = LineChartData(dataSets: dataSets)
        lineData.setDrawValues(false)
        
        let bardata = BarChartData(dataSet: set1)
        bardata.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        bardata.barWidth = 0.2
        
        let data = CombinedChartData()
        data.barData = bardata
        data.lineData = LineChartData(dataSets: dataSets)
        
        caloriesChartView.data = data
        caloriesChartView.noDataText = "You need to provide data for the chart."
    }
    
    func initWeightChart() {
        weightChartView.leftAxis.enabled = false
        let yAxis = weightChartView.rightAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        
        weightChartView.xAxis.labelPosition = .bottom
        weightChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        weightChartView.xAxis.setLabelCount(6, force: false)
        weightChartView.animate(xAxisDuration: 1.0)
        
        setWeightData()
    }
    
    func getMonday(date: Date) -> Date {
        let cal = Calendar.current
        var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
        comps.weekday = 2 // Monday
        let mondayInWeek = cal.date(from: comps)!
        return mondayInWeek
    }
    
    func setWeightData() {
        var cal = Calendar.current
        cal.firstWeekday = 2
        var date = getMonday(date: Date()) //cal.startOfDay(for: Date())
        date = cal.date(byAdding: .weekOfYear, value: -10, to: date)!
        
        var dates = [String]()
        var weeks = [Int]()
        var weights = [Double]()
        var targetWeights = [Double]()
        
        var curMonth = 0
        var curYear = ""
        
        for i in 1 ... 12 {
            dates.append(formatter.string(from: date))
            let week = cal.component(.weekOfYear, from: date)
            curMonth = cal.component(.month, from: date)
            curYear = String(cal.component(.year, from: date))

            weeks.append(week)

            var weeklyWeight = 0
            let weightTracking: [WeightTracking] = DatabaseManager.getInstance().getWeightTracking()
            
            for weight in weightTracking {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy"
                let wDate = dateFormatter.date(from: weight.date)!
                var weightDate = getMonday(date: wDate)
                
                //print("Actual weight Date \(weight.date)")
                print("Actual current Date \(date)")
                
                //print("Formatted weight Date " + dateFormatter.string(from: weightDate))
                print( "Formatted current Date " + reverseFormatter.string(from: date))
                
                if dateFormatter.string(from: weightDate) == formatter.string(from: date) {
                    weeklyWeight = weight.weight
                }
            }
            
            weights.append(Double(weeklyWeight))
            targetWeights.append(UserDefaults.standard.double(forKey: "targetWeight") * 2.2)
            date = cal.date(byAdding: .weekOfYear, value: 1, to: date)!
        }
        
        print(weights);
        var currentEntries: [ChartDataEntry] = []
        for i in 0..<dates.count {
            let dataEntry = ChartDataEntry(x: Double(weeks[i]), y: weights[i])
            currentEntries.append(dataEntry)
        }
        
        var targetEntries: [ChartDataEntry] = []
        for i in 0..<dates.count {
            let dataEntry = ChartDataEntry(x: Double(weeks[i]), y: targetWeights[i])
            targetEntries.append(dataEntry)
        }
        
        let set1 = LineChartDataSet(entries: currentEntries, label: "Your Weight")
        
        set1.mode = .horizontalBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(UIColor(named: "Primary")!)
        
        let set2 = LineChartDataSet(entries: targetEntries, label: "Target")
        
        set2.mode = .cubicBezier
        set2.drawCirclesEnabled = false
        set2.lineWidth = 3
        set2.setColor(UIColor.link)
        
        let dataSets: [LineChartDataSet] = [set1, set2]
        let data = LineChartData(dataSets: dataSets)
        data.setDrawValues(false)
        
        let data1 = LineChartData(dataSet: set2)
        data1.setDrawValues(false)
        
        weightChartView.data = data
    }
    
    weak var axisFormatDelegate: IAxisValueFormatter?

    func addMaskedCorner(view: UIView, size: CGFloat) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.1
        
        view.layer.cornerRadius = size
    }
}
