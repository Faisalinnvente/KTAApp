//
//  MoreViewController.swift
//  KTA
//
//  Created by qadeem on 11/02/2021.
//

import UIKit
import Firebase
import StoreKit

class MoreViewController: UIViewController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent("select_more_tab", parameters: nil)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
    }
    
    @IBAction func termsClicked(_ sender: UIButton) {
        Analytics.logEvent("view_terms_and_conditions", parameters: nil)
        
        guard let url = URL(string: "https://www.ketotracker.app/terms-of-service/") else { return }
        UIApplication.shared.open(url)
        //let vc = storyboard?.instantiateViewController(identifier: "TermsViewController") as! TermsViewController
        //self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func disclamerClicked(_ sender: UIButton) {
        Analytics.logEvent("view_disclamer", parameters: nil)
        
        guard let url = URL(string: "https://www.ketotracker.app/disclaimer/") else { return }
        UIApplication.shared.open(url)
        //let vc = storyboard?.instantiateViewController(identifier: "DisclaimerViewController") as! DisclaimerViewController
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func privacyPolicy(_ sender: UIButton) {
        Analytics.logEvent("view_privacy_policy", parameters: nil)
        
        guard let url = URL(string: "https://www.ketotracker.app/privacy-policy/") else { return }
        UIApplication.shared.open(url)
        //let vc = storyboard?.instantiateViewController(identifier: "DisclaimerViewController") as! DisclaimerViewController
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func feedbackClicked(_ sender: UIButton) {
        Analytics.logEvent("view_feedback", parameters: nil)
        
        let vc = storyboard?.instantiateViewController(identifier: "FeedbackViewController") as! FeedbackViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func inviteClicked(_ sender: UIButton) {
        Analytics.logEvent("invite_family_and_friend", parameters: nil)
        
        let vc = storyboard?.instantiateViewController(identifier: "InviteViewController") as! InviteViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func rateAppClicked(_ sender: UIButton) {
        Analytics.logEvent("rate_and_review_application", parameters: nil)
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "1560905804") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func changeSettingsClicked(_ sender: Any) {
        Analytics.logEvent("view_personal_settings", parameters: nil)
        
        let vc = storyboard?.instantiateViewController(identifier: "PersonalSettingsViewController") as! PersonalSettingsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeNotificationsClicked(_ sender: Any) {
        Analytics.logEvent("view_notifications_settings", parameters: nil)
        
        let vc = storyboard?.instantiateViewController(identifier: "NotificationsSettingsViewController") as! NotificationsSettingsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
