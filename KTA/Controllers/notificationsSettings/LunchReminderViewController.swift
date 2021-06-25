//
//  LunchReminderViewController.swift
//  KTA
//
//  Created by qadeem on 24/03/2021.
//

import UIKit
import UserNotifications
import Firebase

class LunchReminderViewController: UIViewController {
    var notificationsEnabled = false
    var uuid = ""
    @IBOutlet weak var switchToggle: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let formatter = DateFormatter()
    var components = Calendar.current.dateComponents([.hour, .minute], from: Date())
    
    var lunchHour = "12"
    var lunchMinute = "00"
    
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent("view_change_lunch_notifications", parameters: nil)
        initViews()
    }
    
    func initViews() {
        btnSave.layer.cornerRadius = 20.0
        //let components = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
        //reminder.dateComponents = components
        
        formatter.dateStyle = .full
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .compact
        }

        notificationsEnabled = UserDefaults.standard.bool(forKey: "lunchNotifications")
        uuid = UserDefaults.standard.string(forKey: "lunchUUID")!
        
        lunchHour = UserDefaults.standard.string(forKey: "lunchHour") ?? "12"
        lunchMinute = UserDefaults.standard.string(forKey: "lunchMinute") ?? "00"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"

        let date = dateFormatter.date(from: "\(lunchHour):\(lunchMinute)")
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
            Analytics.logEvent("lunch_notifications_enabled", parameters: nil)
            rescheduleNotification()
        } else {
            notificationsEnabled = false
            Analytics.logEvent("lunch_notifications_disabled", parameters: nil)
            cancelNotification()
        }
        
        UserDefaults.standard.set(notificationsEnabled, forKey: "lunchNotifications")
    }
    
    @IBAction func datePickerChange(_ sender: UIDatePicker) {
        components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
    }
    
    func cancelNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [uuid])
    }
    
    func rescheduleNotification() {
        let center = UNUserNotificationCenter.current()

        if notificationsEnabled {
            scheduleNotification(title: "Lunch Meal Time", body: "Time to log Lunch. Please take a moment and log Lunch.")
        }
    }
    
    func scheduleNotification(title: String, body: String) {
        Analytics.logEvent("change_lunch_notifications_time", parameters: ["time": formatter.string(from: datePicker.date)])
        cancelNotification()
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        let trigger = UNCalendarNotificationTrigger(dateMatching: self.components, repeats: true)
        
        let uuid = UUID().uuidString
        UserDefaults.standard.set(uuid, forKey: "lunchUUID")

        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        center.add(request)
        
        UserDefaults.standard.set(components.hour, forKey: "lunchHour")
        UserDefaults.standard.set(components.minute, forKey: "lunchMinute")
    }
    
    @IBAction func save(_ sender: Any) {
        self.rescheduleNotification()
        
        let alert = UIAlertController(title: "Success", message: "Notification settings has been updated", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
