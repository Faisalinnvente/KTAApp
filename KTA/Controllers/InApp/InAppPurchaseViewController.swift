//
//  InAppPurchaseViewController.swift
//  KTA
//
//  Created by qadeem on 28/03/2021.
//

import UIKit
import StoreKit
import Firebase

class InAppPurchaseViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver, UITextViewDelegate {
    @IBOutlet weak var btnStart: UIButton!
    
    @IBOutlet weak var viewMonthly: UIView!
    @IBOutlet weak var viewAnnual: UIView!
    @IBOutlet weak var viewQuarterly: UIView!
    
    @IBOutlet weak var viewAnnualDiscount: UIView!
    @IBOutlet weak var ViewQuarterlyDiscount: UIView!
    
    @IBOutlet weak var lblDiscountOffer: UILabel!
    
    @IBOutlet weak var lblOfferTIme: UILabel!
    @IBOutlet weak var lblOfferHead: UILabel!
    
    @IBOutlet weak var lblMonthHead: UILabel!
    @IBOutlet weak var lblMYearPrice: UILabel!
    @IBOutlet weak var lblMonthPrice: UILabel!
    @IBOutlet weak var lblMonthPM: UILabel!
    @IBOutlet weak var lblMonth5Days: UILabel!
    
    @IBOutlet weak var lblAnnualHead: UILabel!
    @IBOutlet weak var lblAnnualActualP: UILabel!
    @IBOutlet weak var lblAnnualDiscountedP: UILabel!
    @IBOutlet weak var lblAnnualPY: UILabel!
    @IBOutlet weak var lblAnnual5Days: UILabel!
    
    @IBOutlet weak var lblQuarterHead: UILabel!
    @IBOutlet weak var lblQuarterActualP: UILabel!
    @IBOutlet weak var lblQuarterDiscountedP: UILabel!
    @IBOutlet weak var lblQuarterPM: UILabel!
    @IBOutlet weak var lblQuarter5Days: UILabel!
    
    @IBOutlet weak var lblAnnualDiscount: UILabel!
    @IBOutlet weak var lblQuarterDiscount: UILabel!
    
    @IBOutlet weak var lblBottomPriceLine: UILabel!
    @IBOutlet weak var lblChargedToday: UILabel!
    
    @IBOutlet weak var lblPolicies: UITextView!
    
    // 1 form annual, 2 for quartarly, 3 for monthly
    var selectedPlan = 1
    
    // promotions related variables
    var launchCount = 0
    var discountPercentage = 67 //will be 50 for second time and 33 for third time
    var discountPercentageQuarterly = 33
    
    var monthlyActualPrice = 4.99
    var AnnualActualPrice = 59.64
    var QuarterlyActualPrice = 14.91
    
    var AnnualDiscountedPrice = 0.0
    var QuarterlyDiscountedPrice = 0.0
    
    var timer = Timer()
    var minsLeft = 59
    var secLeft = 59
    
    // in app purchase related variables
    var productID = ""
    var myProduct: SKProduct?
    
    var trailStarted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDate()
        initViews()
        
        let text = NSMutableAttributedString(string: "By using this App, you agree to our Terms of Service, Privacy policy and Disclamer.")
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center

        let termsUrl = URL(string: "https://www.ketotracker.app/terms-of-service/")!
        let privacyUrl = URL(string: "https://www.ketotracker.app/terms-of-service/")!
        let disclaimerUrl = URL(string: "https://www.ketotracker.app/terms-of-service/")!

        text.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, text.length))
        text.setAttributes([.link: termsUrl], range: NSMakeRange(36, 16))
        text.setAttributes([.link: privacyUrl], range: NSMakeRange(54, 14))
        text.setAttributes([.link: disclaimerUrl], range: NSMakeRange(73, 10))
        
        text.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, text.length))
        
        lblPolicies.attributedText = text
        lblPolicies.isUserInteractionEnabled = true

        if (launchCount < 2) {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        } else if launchCount > 1 {
            timerLayout()
        }
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }

    
    @objc func update() {
        secLeft = secLeft - 1
        if (secLeft == 0 && minsLeft > 0) {
            minsLeft = minsLeft - 1
            secLeft = 59
            
            loadUserDate()
            initViews()
        } else if (minsLeft == 0 && secLeft == 0) {
            launchCount = launchCount + 1
            UserDefaults.standard.set(launchCount, forKey: "inAppLaunches")
            
            if launchCount == 1 {
                minsLeft = 59
                secLeft = 59
            } else if launchCount > 1 {
                timer.invalidate()
            }
            
            loadUserDate()
            initViews()
        }
    
        timerLayout()
    }
    
    func timerLayout() {
        if (launchCount < 2) {
            if (secLeft > 9 && minsLeft > 9) {
                lblOfferTIme.text = "0:\(minsLeft):\(secLeft)"
            } else if (secLeft > 9 && minsLeft < 10) {
                lblOfferTIme.text = "0:0\(minsLeft):\(secLeft)"
            } else if (secLeft < 10 && minsLeft < 10) {
                lblOfferTIme.text = "0:0\(minsLeft):0\(secLeft)"
            }
            
        } else {
            lblOfferHead.text = "Introductory Offer"
            lblOfferTIme.text = "Price will go up in near future release"
            lblOfferTIme.textColor = .gray
            lblOfferTIme.font = lblOfferHead.font.withSize(15)
            lblOfferTIme.numberOfLines = 0
        }
    }
    
    func loadUserDate() {
        // setting trial period 
        //if UserDefaults.standard.bool(forKey: "trailStarted") {
            btnStart.setTitle("SUBSCRIBE NOW", for: .normal)
            trailStarted = true
        //} else {
          //  btnStart.setTitle("START USING FREE", for: .normal)
          //  trailStarted = false
        //}
        
        // Setting InApp Launched
        UserDefaults.standard.set(true, forKey: "inAppLaunched")
        launchCount = UserDefaults.standard.integer(forKey: "inAppLaunches")
        
        if launchCount == 0 {
            discountPercentage = 67
            discountPercentageQuarterly = 33
            
            AnnualDiscountedPrice = 19.99
            QuarterlyDiscountedPrice = 9.99
            
            minsLeft = 9
            secLeft = 59
        } else if launchCount == 1 {
            discountPercentage = 50
            discountPercentageQuarterly = 20
            
            AnnualDiscountedPrice = 29.99
            QuarterlyDiscountedPrice = 11.99
            
            minsLeft = 59
            secLeft = 59
        } else {
            discountPercentage = 33
            discountPercentageQuarterly = 7
            
            AnnualDiscountedPrice = 39.99
            QuarterlyDiscountedPrice = 13.99
        }
        
        lblAnnualDiscountedP.text = "$ \(AnnualDiscountedPrice)"
        lblQuarterDiscountedP.text = "$ \(QuarterlyDiscountedPrice)"
        
        lblAnnualDiscount.text = "\(discountPercentage)%"
        lblQuarterDiscount.text = "\(discountPercentageQuarterly)%"
        
        UserDefaults.standard.set(launchCount + 1, forKey: "inAppLaunches")
    }
    
    func showDiscountOffer() {
        var myString:NSString = "Welcome Offer \(discountPercentage)% Off " as NSString
        var myMutableString = NSMutableAttributedString(string: myString as String)
        
        if launchCount < 2 {
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:13,length: 8))
        } else {
            myString = "Introductory Offer \(discountPercentage)% Off " as NSString
            myMutableString = NSMutableAttributedString(string: myString as String)
            
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:18,length: 8))
        }
        
        lblDiscountOffer.attributedText = myMutableString
    }
    
    func initViews() {
        showDiscountOffer()
        btnStart.layer.cornerRadius = 20.0
        
        addCornerRadius(view: viewMonthly, radius: 10.0)
        addCornerRadius(view: viewAnnual, radius: 10.0)
        addCornerRadius(view: viewQuarterly, radius: 10.0)
        
        addCornerRadius(view: viewAnnualDiscount, radius: 5.0)
        addCornerRadius(view: ViewQuarterlyDiscount, radius: 5.0)
        
        addGestures()
        
        if selectedPlan == 1 {
            selectAnnualPlan()
        } else if selectedPlan == 2 {
            selectQuarterlyPlan()
        } else if selectedPlan == 3 {
            selectMonthlyPlan()
        }
    }
    
    func selectAnnualPlan() {
        resetSelections()
        selectAnnualview()
        
        lblBottomPriceLine.text = "That is $\(round(100 * (AnnualDiscountedPrice/12))/100) per month."
        lblChargedToday.text = "You will be charged $\(round(100 * (AnnualDiscountedPrice))/100) today."
        selectedPlan = 1
    }
    
    func selectMonthlyPlan() {
        resetSelections()
        SelectMonthlyView()
        
        lblBottomPriceLine.text = "That is $\(round(100 * (monthlyActualPrice))/100) per month."
        lblChargedToday.text = "You will be charged $\(round(100 * (monthlyActualPrice))/100) today."
        selectedPlan = 3
    }
    
    func selectQuarterlyPlan() {
        resetSelections()
        selectQuarterlyView()
        
        lblBottomPriceLine.text = "That is $\(round(100 * (QuarterlyDiscountedPrice/3))/100) per month."
        lblChargedToday.text = "You will be charged $\(round(100 * (QuarterlyDiscountedPrice))/100) today."
        selectedPlan = 2
    }
    
    func SelectMonthlyView() {
        viewMonthly.layer.borderWidth = 2
        viewMonthly.layer.borderColor = UIColor(named: "Primary")?.cgColor
        
        viewMonthly.backgroundColor = .white
        
        lblMonthHead.textColor = .black
        lblMYearPrice.textColor = .gray
        lblMonthPrice.textColor = .red
        lblMonthPM.textColor = .black
        lblMonth5Days.textColor = .darkGray
        
        productID = "com.sggroups.keto.monthly"
        fetchProducts()
    }
    
    func selectAnnualview() {
        viewAnnual.layer.borderWidth = 2
        viewAnnual.layer.borderColor = UIColor(named: "Primary")?.cgColor
        
        viewAnnual.backgroundColor = .white
        
        lblAnnualHead.textColor = .black
        lblAnnualActualP.textColor = .gray
        lblAnnualDiscountedP.textColor = .red
        lblAnnualPY.textColor = .black
        lblAnnual5Days.textColor = .darkGray
        
        if launchCount == 0 {
            productID = "com.sggroups.keto.annual67" // Welcome Offer 67, 19.99$ for US , 1.67$ per month
        } else if launchCount == 1 {
            productID = "com.sggroups.keto.annual50" // Welcome Offer 50 , 29.99 , 2.5$ permonth
        } else {
            productID = "com.sggroups.keto.annual33" // Introductory Offer 33%, 39.99 , 3.33$ permonth,
        }
        
        fetchProducts()
    }
    
    func selectQuarterlyView() {
        viewQuarterly.layer.borderWidth = 2
        viewQuarterly.layer.borderColor = UIColor(named: "Primary")?.cgColor
        
        viewQuarterly.backgroundColor = .white
        
        lblQuarterHead.textColor = .black
        lblQuarterActualP.textColor = .gray
        lblQuarterDiscountedP.textColor = .red
        lblQuarterPM.textColor = .black
        lblQuarter5Days.textColor = .darkGray
        
        if launchCount == 0 {
            productID = "com.sggroups.keto.quarter1" // Welcome Offer 67, 9.99 , 3.33$ permonth
        } else if launchCount == 1 {
            productID = "com.sggroups.keto.quarter2" // Welcome Offer 50, 11.99, 4.0$ permonth
        } else {
            productID = "com.sggroups.keto.quarterintroductory" // Introductory , 13.99, 4.66$ permonth
        }
        
        fetchProducts()
    }
    
    func resetSelections() {
        viewMonthly.layer.borderWidth = 0
        viewMonthly.backgroundColor = UIColor(named: "customNavy")
        
        lblMonthHead.textColor = .white
        lblMYearPrice.textColor = UIColor(named: "beige")
        lblMonthPrice.textColor = .systemGray5
        lblMonthPM.textColor = .systemGray5
        lblMonth5Days.textColor = .systemGray5
        
        viewAnnual.layer.borderWidth = 0
        viewAnnual.backgroundColor = UIColor(named: "customNavy")
        
        lblAnnualHead.textColor = .white
        lblAnnualActualP.textColor = .systemGray5
        lblAnnualDiscountedP.textColor = .lightGray
        lblAnnualPY.textColor = .systemGray5
        lblAnnual5Days.textColor = .systemGray5
        
        viewQuarterly.layer.borderWidth = 0
        viewQuarterly.backgroundColor = UIColor(named: "customNavy")
        
        lblQuarterHead.textColor = .systemGray5
        lblQuarterActualP.textColor = .systemGray5
        lblQuarterDiscountedP.textColor = .lightGray
        lblQuarterPM.textColor = .systemGray5
        lblQuarter5Days.textColor = .systemGray5
    }
    
    func addCornerRadius(view: UIView, radius: CGFloat) {
        view.layer.cornerRadius = radius
    }
    
    func addGestures() {
        let annualGesture = UITapGestureRecognizer(target: self, action: #selector(AnnualTapped(_:)))
        annualGesture.numberOfTapsRequired = 1
        annualGesture.numberOfTouchesRequired = 1
        
        viewAnnual.addGestureRecognizer(annualGesture);
        viewAnnual.isUserInteractionEnabled = true
        
        let monthlyGesture = UITapGestureRecognizer(target: self, action: #selector(MonthlyTapped(_:)))
        monthlyGesture.numberOfTapsRequired = 1
        monthlyGesture.numberOfTouchesRequired = 1
        
        viewMonthly.addGestureRecognizer(monthlyGesture);
        viewMonthly.isUserInteractionEnabled = true
        
        let QuarterlyGesture = UITapGestureRecognizer(target: self, action: #selector(QuarterlyTapper(_:)))
        QuarterlyGesture.numberOfTapsRequired = 1
        QuarterlyGesture.numberOfTouchesRequired = 1
        
        viewQuarterly.addGestureRecognizer(QuarterlyGesture);
        viewQuarterly.isUserInteractionEnabled = true
    }
    
    @objc func AnnualTapped(_ gesture: UITapGestureRecognizer) {
        selectAnnualPlan()
    }
    
    @objc func MonthlyTapped(_ gesture: UITapGestureRecognizer) {
        selectMonthlyPlan()
    }
    
    @objc func QuarterlyTapper(_ gesture: UITapGestureRecognizer) {
        selectQuarterlyPlan()
    }
    
    @IBAction func startClicked(_ sender: UIButton) {
        //if trailStarted {
            //UserDefaults.standard.set(true, forKey: "productPurchased")
            
            guard let myProduct = self.myProduct else {
                let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                present(alert, animated: true, completion: nil)
                
                return
            }
            
            if SKPaymentQueue.canMakePayments() {
                let payment = SKPayment(product: myProduct)
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(payment)
            }
        /*} else {
            UserDefaults.standard.set(Date(), forKey: "trailStartDate")
            
            let vc = storyboard?.instantiateViewController(identifier: "ThanksViewController") as! ThanksViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        */
    }
    
    func navigateToThanks() {
        //event
        Analytics.logEvent("subscribe_service", parameters: nil)
        
        if selectedPlan == 1 { // annual
            //properties
            Analytics.setUserProperty("subscribe_12_months", forName: "subscription_type")
            Analytics.setUserProperty(String(AnnualDiscountedPrice), forName: "subscription_price_value")
        } else if selectedPlan == 2 { // quarterly
            //properties
            Analytics.setUserProperty("subscribe_3_months", forName: "subscription_type")
            Analytics.setUserProperty(String(QuarterlyDiscountedPrice), forName: "subscription_price_value")
        } else if selectedPlan == 3 { // monthly
            //properties
            Analytics.setUserProperty("subscribe_1_month", forName: "subscription_type")
            Analytics.setUserProperty(String(monthlyActualPrice), forName: "subscription_price_value")
        }
        
        let vc = storyboard?.instantiateViewController(identifier: "ThanksViewController") as! ThanksViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func navigateToHome() {
        let vc = storyboard?.instantiateViewController(identifier: "TabBarViewController") as! TabBarViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    // Inapp purchases
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: [self.productID])
        request.delegate = self
        
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response)
        if let product = response.products.first {
            myProduct = product
            print(product.productIdentifier)
            print(product.price)
            print(product.localizedTitle)
            print(product.localizedDescription)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
     
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            switch transaction.transactionState {
            case .purchasing:
                // do nothig
                break
            case .purchased:
                // unlock their item
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                
                UserDefaults.standard.set(true, forKey: "productPurchased")
                navigateToThanks()
                break
            case .restored:
                //navigateToThanks()
                break
            case .failed, .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            default:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            }
        }
    }
}
