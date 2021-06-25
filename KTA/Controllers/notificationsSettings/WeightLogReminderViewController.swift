//
//  WeightLogReminderViewController.swift
//  KTA
//
//  Created by qadeem on 24/03/2021.
//

import UIKit
import UserNotifications
import Firebase

class WeightLogReminderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var switchToggle: UISwitch!
    @IBOutlet weak var daysPicker: UIPickerView!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var daysPickerData: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var notificationsEnabled = false
    var uuid = ""
    
    var weekday: Int = 0
    
    var weightHour = "12"
    var weightMinute = "00"
    
    let formatter = DateFormatter()
    var components = Calendar.current.dateComponents([.hour, .minute], from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Analytics.logEvent("view_change_weight_notifications", parameters: nil)
        initViews()
    }
    
    func initViews() {
        btnSave.layer.cornerRadius = 20.0
        
        setPickerDelegates()
        
        formatter.dateStyle = .full
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .compact
        }
        
        notificationsEnabled = UserDefaults.standard.bool(forKey: "weightNotifications")
        uuid = UserDefaults.standard.string(forKey: "weightUUID")!
        
        weekday = UserDefaults.standard.integer(forKey: "weightWeekday") ?? 0
        daysPicker.selectRow(weekday, inComponent: 0, animated: false)
        
        weightHour = UserDefaults.standard.string(forKey: "weightHour") ?? "12"
        weightMinute = UserDefaults.standard.string(forKey: "weightMinute") ?? "00"
        
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"

        let date = dateFormatter.date(from: "\(weightHour):\(weightMinute)")
        datePicker.date = date!
        
        components = Calendar.current.dateComponents([.hour, .minute], from: date!)
        
        if notificationsEnabled {
            switchToggle.isOn = true
        } else {
            switchToggle.isOn = false
            cancelNotification()
        }
    }
    
    @IBAction func toggleNotifications(_ sender: UISwitch) {
        if sender.isOn {
            notificationsEnabled = true
            Analytics.logEvent("weight_notifications_enabled", parameters: nil)
            rescheduleNotification()
        } else {
            notificationsEnabled = false
            Analytics.logEvent("weight_notifications_disabled", parameters: nil)
            cancelNotification()
        }
        
        UserDefaults.standard.set(notificationsEnabled, forKey: "weightNotifications")
    }
    
    @IBAction func datePickerChange(_ sender: UIDatePicker) {
        components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
    }
    
    func cancelNotification() {
        uuid = UserDefaults.standard.string(forKey: "weightUUID")!
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [uuid])
    }
    
    func rescheduleNotification() {
        let center = UNUserNotificationCenter.current()

        if notificationsEnabled {
            scheduleNotification(title: "Log Weight", body: "What is your weight this week? Kindly log your weight")
        }
    }
    
    func scheduleNotification(title: String, body: String) {
        Analytics.logEvent("change_dinner_notifications_day", parameters: ["day": weekday])
        cancelNotification()
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        
        dateComponents.hour = components.hour
        dateComponents.minute = components.minute
        
        dateComponents.weekday = self.weekday
        
        let newUuid = UUID().uuidString
        UserDefaults.standard.set(newUuid, forKey: "weightUUID")
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: newUuid, content: content, trigger: trigger)
        center.add(request)
        
        UserDefaults.standard.set(components.hour, forKey: "weightHour")
        UserDefaults.standard.set(components.minute, forKey: "weightMinute")
        
        UserDefaults.standard.set(self.weekday, forKey: "weightWeekday")
    }
    
    func setPickerDelegates() {
        daysPicker.delegate = self
        daysPicker.dataSource = self
    }
    
    // picker View Delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return daysPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return daysPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label:UILabel
        if let v = view as? UILabel{
            label = v
        }
        else{
            label = UILabel()
        }
            
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 15)
            
        label.text = daysPickerData[row]
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.weekday = row
        print(self.daysPickerData[row])
    }
    
    @IBAction func save(_ sender: Any) {
        self.rescheduleNotification()
        
        let alert = UIAlertController(title: "Success", message: "Notification settings has been updated", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
