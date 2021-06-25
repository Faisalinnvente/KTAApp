//
//  EntryViewController.swift
//  KTA
//
//  Created by qadeem on 07/02/2021.
//

import UIKit
import FMDB
 
class EntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if Core.shared.isNewUser() {
            if UserDefaults.standard.bool(forKey: "inAppLaunched") {
                navigateToPurchase()
            } else {
                let vc = storyboard?.instantiateViewController(identifier: "InfoStartViewController") as! InfoStartViewController
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            }
        } else {
            //let trialStartDate: Date = UserDefaults.standard.object(forKey: "trailStartDate") as! Date
            let trialStartDate: Date = Date()
            
            if daysBetween(start: trialStartDate, end: Date()) > 5 { // change this for 5 days
                if UserDefaults.standard.bool(forKey: "productPurchased") {
                    //navigateToTabBar()
                    navigateToPurchase()
                } else {
                    //navigateToTabBar()
                    navigateToPurchase()
                }
                
            } else {
                //navigateToTabBar()
                navigateToPurchase()
            }
        }
    }
    
    func navigateToPurchase() {
        let vc = storyboard?.instantiateViewController(identifier: "InAppPurchaseViewController") as! InAppPurchaseViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func navigateToTabBar() {
        let vc = storyboard?.instantiateViewController(identifier: "TabBarViewController") as! TabBarViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    func minutesBetweenDates(_ oldDate: Date, _ newDate: Date) -> CGFloat {

        //get both times sinces refrenced date and divide by 60 to get minutes
        let newDateMinutes = newDate.timeIntervalSinceReferenceDate/60
        let oldDateMinutes = oldDate.timeIntervalSinceReferenceDate/60

        //then return the difference
        return CGFloat(newDateMinutes - oldDateMinutes)
    }
}

class Core {
    static let shared = Core()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
