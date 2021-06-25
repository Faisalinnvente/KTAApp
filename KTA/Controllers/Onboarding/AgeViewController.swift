//
//  AgeViewController.swift
//  KTA
//
//  Created by qadeem on 07/02/2021.
//

import UIKit
import Firebase

class AgeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var agePicker: UIPickerView!
    @IBOutlet weak var monthPicker: UIPickerView!
    
    var yearPickerData: [String] = [String]()
    var monthPickerData: [String] = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPickerViewData();
        addMaskedCorner(view: bottomView, size: 30.0)
        
        agePicker.delegate = self
        agePicker.dataSource = self
        
        monthPicker.delegate = self
        monthPicker.dataSource = self
        
        agePicker.selectRow(20, inComponent: 0, animated: false)
        monthPicker.selectRow(0, inComponent: 0, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
    }

    func initPickerViewData() {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        let currentYear =  Int(components.year!)
        print(currentYear)
        
        for x in 1970..<currentYear {
            yearPickerData.append(String(x))
        }
    }
    
    func addMaskedCorner(view: UIView, size: CGFloat) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.1
        
        view.layer.cornerRadius = size
        view.layer.maskedCorners = [.layerMaxXMinYCorner]
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        //event
        Analytics.logEvent("select_birth_year", parameters: ["birth_year": yearPickerData[agePicker.selectedRow(inComponent: 0)] ])
        Analytics.setUserProperty(yearPickerData[agePicker.selectedRow(inComponent: 0)], forName: "birth_year")
        
        UserDefaults.standard.set(yearPickerData[agePicker.selectedRow(inComponent: 0)], forKey: "bornYear")
        UserDefaults.standard.set(monthPicker.selectedRow(inComponent: 0), forKey: "bornMonth")
        print(monthPicker.selectedRow(inComponent: 0))
        
        let vc = storyboard?.instantiateViewController(identifier: "HeightViewController") as! HeightViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    //UI PickerView methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return yearPickerData.count
        } else if pickerView.tag == 2 {
            return monthPickerData.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return yearPickerData[row]
        } else if pickerView.tag == 2 {
            return monthPickerData[row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 65.0
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
            label.font = UIFont(name: "Helvetica", size: 25)
            
            if pickerView.tag == 1 {
                label.text = yearPickerData[row]
            } else if pickerView.tag == 2 {
                label.text = monthPickerData[row]
            } else {
                label.text = ""
            }

            return label
        }
}
