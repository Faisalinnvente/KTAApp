//
//  UpdateAgeViewController.swift
//  KTA
//
//  Created by qadeem on 18/03/2021.
//

import UIKit
import Firebase

class UpdateAgeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var agePicker: UIPickerView!
    @IBOutlet weak var monthPicker: UIPickerView!
    
    @IBOutlet weak var btnSave: UIButton!
    
    var yearPickerData: [String] = [String]()
    var monthPickerData: [String] = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    
    var bornYear: Int = 1970
    var bornMonth: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        Analytics.logEvent("view_update_age", parameters: nil)
        initViews()
    }
    
    func initViews() {
        btnSave.layer.cornerRadius = 20.0
        
        bornYear = UserDefaults.standard.integer(forKey: "bornYear")
        bornMonth = UserDefaults.standard.integer(forKey: "bornMonth")
        
        setupPickerDelegates()
        initPickerViewData()
    }
    
    func setupPickerDelegates() {
        agePicker.delegate = self
        agePicker.dataSource = self
        
        monthPicker.delegate = self
        monthPicker.dataSource = self
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
        
        var bornYearIndex = yearPickerData.firstIndex(of: String(bornYear))
        //var bornMonthIndex = monthPickerData.firstIndex(of: String(bornMonth))
        
        agePicker.selectRow(bornYearIndex ?? 0, inComponent: 0, animated: false)
        monthPicker.selectRow(bornMonth ?? 0, inComponent: 0, animated: false)
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
    
    @IBAction func saveAge(_ sender: Any) {
        UserDefaults.standard.set(yearPickerData[agePicker.selectedRow(inComponent: 0)], forKey: "bornYear")
        UserDefaults.standard.set(monthPicker.selectedRow(inComponent: 0), forKey: "bornMonth")
        
        Analytics.logEvent("update_age", parameters: ["birth_year": yearPickerData[agePicker.selectedRow(inComponent: 0)] ])
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
