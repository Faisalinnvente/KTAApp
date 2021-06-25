//
//  WaterReminderViewController.swift
//  KTA
//
//  Created by qadeem on 24/03/2021.
//

import UIKit
import UserNotifications
import Firebase

class WaterReminderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var switchToggle: UISwitch!
    @IBOutlet weak var hoursPicker: UIPickerView!
    @IBOutlet weak var btnSave: UIButton!
    
    var hoursPickerData: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var notificationsEnabled = false
    var uuid = ""
    
    @IBOutlet weak var startPicker: UIDatePicker!
    @IBOutlet weak var endPicker: UIDatePicker!
    
    var hours:Double = 1.0
    
    var waterStep = 1
    
    var waterStartHour = "7"
    var waterStartMinute = "00"
    
    var waterEndHour = "22"
    var waterEndMinute = "00"
    
    let formatter = DateFormatter()
    var componentsStart = Calendar.current.dateComponents([.hour, .minute], from: Date())
    var componentsEnd = Calendar.current.dateComponents([.hour, .minute], from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Analytics.logEvent("view_change_water_notifications", parameters: nil)
        initViews()
    }
    
    func initViews() {
        btnSave.layer.cornerRadius = 20.0
        
        formatter.dateStyle = .full
        if #available(iOS 13.4, *) {
            startPicker.preferredDatePickerStyle = .compact
            endPicker.preferredDatePickerStyle = .compact
        }
        
        self.waterStep = UserDefaults.standard.integer(forKey: "waterStep")
        
        waterStartHour = UserDefaults.standard.string(forKey: "waterStartHour") ?? "7"
        waterStartMinute = UserDefaults.standard.string(forKey: "waterStartMinute") ?? "00"
        
        waterEndHour = UserDefaults.standard.string(forKey: "waterEndHour") ?? "22"
        waterEndMinute = UserDefaults.standard.string(forKey: "waterEndMinute") ?? "00"
        
        setPickerDelegates()
        
        hoursPicker.selectRow(self.waterStep - 1, inComponent: 0, animated: false)
        notificationsEnabled = UserDefaults.standard.bool(forKey: "waterNotifications")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"

        let dateStart = dateFormatter.date(from: "\(waterStartHour):\(waterStartMinute)")
        startPicker.date = dateStart!
        componentsStart = Calendar.current.dateComponents([.hour, .minute], from: dateStart!)
        
        let dateEnd = dateFormatter.date(from: "\(waterEndHour):\(waterEndMinute)")
        endPicker.date = dateEnd!
        componentsEnd = Calendar.current.dateComponents([.hour, .minute], from: dateEnd!)
        
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
            Analytics.logEvent("water_notifications_enabled", parameters: nil)
            rescheduleNotification()
        } else {
            notificationsEnabled = false
            Analytics.logEvent("water_notifications_disabled", parameters: nil)
            cancelNotification()
        }
        
        UserDefaults.standard.set(notificationsEnabled, forKey: "waterNotifications")
    }
    
    @IBAction func startPickerChange(_ sender: UIDatePicker) {
        componentsStart = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
    }
    
    @IBAction func endPickerChange(_ sender: UIDatePicker) {
        componentsEnd = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
    }
    
    func cancelNotification() {
        let wateruuids: [String] = UserDefaults.standard.object(forKey: "waterUUIDs") as! [String]

        //for uuid in wateruuids {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: wateruuids)
        center.removeDeliveredNotifications(withIdentifiers: wateruuids)
        //}
    }
    
    func rescheduleNotification() {
        let center = UNUserNotificationCenter.current()

        if notificationsEnabled {
            scheduleNotification(title: "Drink Water", body: "Take a glass of water please and log it in the App.")
        }
    }
    
    func scheduleNotification(title: String, body: String) {
        Analytics.logEvent("change_water_notifications_time", parameters: ["notif_after_every_hours": hours])
        cancelNotification()
        
        var uuids: [String] = []
        var dateComponents = DateComponents()
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default

        for index in stride(from: componentsStart.hour ?? 7, to: componentsEnd.hour ?? 22, by: waterStep) {
            print(index)
            let uuid = UUID().uuidString
            uuids.append(uuid)
            
            dateComponents.hour = index
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
            center.add(request)
        }
        
        UserDefaults.standard.set(uuids, forKey: "waterUUIDs")
        UserDefaults.standard.set(true, forKey: "waterNotifications")
        
        UserDefaults.standard.set(componentsStart.hour, forKey: "waterStartHour")
        UserDefaults.standard.set(componentsStart.minute, forKey: "waterStartMinute")
        
        UserDefaults.standard.set(componentsEnd.hour, forKey: "waterEndHour")
        UserDefaults.standard.set(componentsEnd.minute, forKey: "waterEndMinute")
        
        UserDefaults.standard.set(self.waterStep, forKey: "waterStep")
    }
    
    func setPickerDelegates() {
        hoursPicker.delegate = self
        hoursPicker.dataSource = self
    }
    
    // picker View Delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hoursPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hoursPickerData[row]
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
            
        label.text = hoursPickerData[row]
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.hours = Double(hoursPickerData[row]) ?? 0.0
        self.waterStep = Int(hoursPickerData[row]) ?? 0
        
        print(hoursPickerData[row])
    }
    
    @IBAction func save(_ sender: Any) {
        self.rescheduleNotification()
        
        let alert = UIAlertController(title: "Success", message: "Notification settings has been updated", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
