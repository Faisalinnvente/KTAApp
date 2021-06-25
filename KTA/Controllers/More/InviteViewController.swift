//
//  InviteViewController.swift
//  KTA
//
//  Created by qadeem on 12/02/2021.
//

import UIKit
import MessageUI
import FBSDKShareKit
import Social
//import FBSDKShareDialog
import FBSDKCoreKit

class InviteViewController: UIViewController, MFMailComposeViewControllerDelegate{
    var appStoreLink = "https://appstoreconnect.apple.com/apps/1560902906/appstore/info"
    var shareContent = "Lose Weight, Stay Fit and Enjoy Delicious Ketogenic Recipes, Download our App from App Store and start loosing weight today.Visit Now https://www.ketotracker.app/"
    
    let items: [Any] = ["Lose Weight, Stay Fit and Enjoy Delicious Ketogenic Recipes, Download our App from App Store and start loosing weight today.", URL(string: "https://www.ketotracker.app/")!]
    
    @IBOutlet weak var viewShare: UIView!
    @IBOutlet weak var btnWhatsapp: UIImageView!
    @IBOutlet weak var btnFb: UIImageView!
    @IBOutlet weak var btnFBMessanger: UIImageView!
    @IBOutlet weak var btnInsta: UIImageView!
    @IBOutlet weak var btnTwitter: UIImageView!
    @IBOutlet weak var btnTelegram: UIImageView!
    @IBOutlet weak var btnLinkedIn: UIImageView!
    @IBOutlet weak var btnEmail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    
    func initViews() {
        addMaskedCorner(view: viewShare, size: 20.0)
        
        addGestures()
    }
    
    func addMaskedCorner(view: UIView, size: CGFloat) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.1
        
        view.layer.cornerRadius = size
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    @IBAction func copyShareLink(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = appStoreLink
    }
    
    func addGestures() {
        let whatsappGesture = UITapGestureRecognizer(target: self, action: #selector(openWhatsapp(_:)))
        whatsappGesture.numberOfTapsRequired = 1
        whatsappGesture.numberOfTouchesRequired = 1
        
        btnWhatsapp.addGestureRecognizer(whatsappGesture);
        btnWhatsapp.isUserInteractionEnabled = true
        
        let fbGesture = UITapGestureRecognizer(target: self, action: #selector(openFb(_:)))
        fbGesture.numberOfTapsRequired = 1
        fbGesture.numberOfTouchesRequired = 1
        
        btnFb.addGestureRecognizer(fbGesture);
        btnFb.isUserInteractionEnabled = true
        
        let msgGesture = UITapGestureRecognizer(target: self, action: #selector(openMessanger(_:)))
        msgGesture.numberOfTapsRequired = 1
        msgGesture.numberOfTouchesRequired = 1
        
        btnFBMessanger.addGestureRecognizer(msgGesture);
        btnFBMessanger.isUserInteractionEnabled = true
        
        let linkedIn = UITapGestureRecognizer(target: self, action: #selector(openLinkedIn(_:)))
        linkedIn.numberOfTapsRequired = 1
        linkedIn.numberOfTouchesRequired = 1
        
        btnLinkedIn.addGestureRecognizer(linkedIn);
        btnLinkedIn.isUserInteractionEnabled = true
        
        let twitter = UITapGestureRecognizer(target: self, action: #selector(openTwitter(_:)))
        twitter.numberOfTapsRequired = 1
        twitter.numberOfTouchesRequired = 1
        
        btnTwitter.addGestureRecognizer(twitter);
        btnTwitter.isUserInteractionEnabled = true
        
        let telegram = UITapGestureRecognizer(target: self, action: #selector(openTelegram(_:)))
        telegram.numberOfTapsRequired = 1
        telegram.numberOfTouchesRequired = 1
        
        btnTelegram.addGestureRecognizer(telegram);
        btnTelegram.isUserInteractionEnabled = true
        
        let instagram = UITapGestureRecognizer(target: self, action: #selector(openInsta(_:)))
        instagram.numberOfTapsRequired = 1
        instagram.numberOfTouchesRequired = 1
        
        btnInsta.addGestureRecognizer(instagram);
        btnInsta.isUserInteractionEnabled = true
        
        let mail = UITapGestureRecognizer(target: self, action: #selector(openMail(_:)))
        mail.numberOfTapsRequired = 1
        mail.numberOfTouchesRequired = 1
        
        btnEmail.addGestureRecognizer(mail);
        btnEmail.isUserInteractionEnabled = true
    }
    
    @objc func openWhatsapp(_ gesture: UITapGestureRecognizer) {
        let whatsappURL:NSURL? = NSURL(string: "whatsapp://send?text=" + shareContent)
        if (UIApplication.shared.canOpenURL(whatsappURL! as URL)) {
            UIApplication.shared.openURL(whatsappURL! as URL)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please install whatsapp.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func openFb(_ gesture: UITapGestureRecognizer) {
        guard let url = URL(string: "https://www.ketotracker.app/") else { return }
        let content = ShareLinkContent()
        content.contentURL = url
        
        let shareDialog = ShareDialog()
        shareDialog.shareContent = content
        
        guard shareDialog.canShow else {
            print("Facebook must be installed in order to share to it")
            presentActivityViewController()
            return
        }

        do {
            try shareDialog.show()
        } catch {
            print(error)
            presentActivityViewController()
        }
    }
    
    @objc func openMessanger(_ gesture: UITapGestureRecognizer) {
        guard let url = URL(string: "https://www.ketotracker.app/") else { return }
        let content = ShareLinkContent()
        content.contentURL = url
        
        let messageDialog = MessageDialog()
        messageDialog.shareContent = content

        guard messageDialog.canShow else {
            print("Facebook Messenger must be installed in order to share to it")
            presentActivityViewController()
            return
        }
        
        do {
            try messageDialog.show()
        } catch {
            print(error)
            presentActivityViewController()
        }
    }
    
    @objc func openInsta(_ gesture: UITapGestureRecognizer) {
        //guard let url = URL(string: "https://www.instagram.com/ketotrackerapp/") else { return }
        //UIApplication.shared.open(url)
        presentActivityViewController()
    }
    
    @objc func openTwitter(_ gesture: UITapGestureRecognizer) {
        //guard let url = URL(string: "https://www.twitter.com/ketotracker") else { return }
        //UIApplication.shared.open(url)
        //presentActivityViewController()
        
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            vc.setInitialText(shareContent)
            present(vc, animated: true)
        } else {
            presentActivityViewController()
        }
    }
    
    @objc func openTelegram(_ gesture: UITapGestureRecognizer) {
        presentActivityViewController()
    }
    
    @objc func openLinkedIn(_ gesture: UITapGestureRecognizer) {
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeLinkedIn) {
            vc.setInitialText(shareContent)
            present(vc, animated: true)
        } else {
            presentActivityViewController()
        }
    }
    
    @objc func openMail(_ gesture: UITapGestureRecognizer) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([""])
            mail.setMessageBody(shareContent, isHTML: true)

            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Email not found", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentActivityViewController() {
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}

