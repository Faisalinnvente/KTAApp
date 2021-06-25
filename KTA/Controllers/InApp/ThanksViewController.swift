//
//  ThanksViewController.swift
//  KTA
//
//  Created by qadeem on 28/03/2021.
//

import UIKit
import SAConfettiView
import Firebase

class ThanksViewController: UIViewController {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewWatch: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    
    func initViews() {
        viewWatch.layer.cornerRadius = 20.0
        btnContinue.layer.cornerRadius = 20.0
        
        addGestures()
        initConfetti()
    }

    func initConfetti() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)

        confettiView.type = .Image(UIImage(named: "confetiiElipse")!)
        confettiView.intensity = 0.75
        confettiView.startConfetti()
        
        self.view.bringSubviewToFront(self.viewContainer)
    }
    
    func addGestures() {
        let watchTapGesture = UITapGestureRecognizer(target: self, action: #selector(openYoutubeLink(_:)))
        watchTapGesture.numberOfTapsRequired = 1
        watchTapGesture.numberOfTouchesRequired = 1
        
        viewWatch.addGestureRecognizer(watchTapGesture);
        viewWatch.isUserInteractionEnabled = true
    }
    
    @objc func openYoutubeLink(_ gesture: UITapGestureRecognizer) {
        //let youtubeUrl = NSURL(string:"https://www.youtube.com/watch?v=\(youtubeId)")!
        //event
        Analytics.logEvent("select_watch_video", parameters: nil)
        
        let youtubeUrl = NSURL(string:"https://www.youtube.com")!
        UIApplication.shared.openURL(youtubeUrl as URL)
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "StartJourneyViewController") as! StartJourneyViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
