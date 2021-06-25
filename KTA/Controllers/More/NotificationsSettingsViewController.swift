//
//  NotificationsSettingsViewController.swift
//  KTA
//
//  Created by qadeem on 18/03/2021.
//

import UIKit

class NotificationsSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func brReminderClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "BreakFastReminderViewController") as! BreakFastReminderViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func luReminderClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "LunchReminderViewController") as! LunchReminderViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func dnReminderClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "DinnerReminderViewController") as! DinnerReminderViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func wiReminderClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "WaterReminderViewController") as! WaterReminderViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func lwReminderClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "WeightLogReminderViewController") as! WeightLogReminderViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
