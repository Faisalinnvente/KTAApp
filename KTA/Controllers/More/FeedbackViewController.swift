//
//  FeedbackViewController.swift
//  KTA
//
//  Created by qadeem on 12/02/2021.
//

import UIKit
import MessageUI
import Firebase

class FeedbackViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var buttonSubmit: UIButton!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFeedback: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSubmit.layer.cornerRadius = 20
        
        txtName.delegate = self
        txtEmail.delegate = self
        txtFeedback.delegate = self
        txtFeedback.returnKeyType = UIReturnKeyType.done
    }
    
    @IBAction func submitClicked(_ sender: UIButton) {
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            Analytics.logEvent("submit_feedback", parameters: nil)
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([""])
            mail.setMessageBody(txtFeedback.text, isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
}
