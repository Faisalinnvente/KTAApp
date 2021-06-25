//
//  GoalWeightViewController.swift
//  KTA
//
//  Created by qadeem on 07/02/2021.
//

import UIKit
import NMMultiUnitRuler
import Firebase

class GoalWeightViewController: UIViewController, NMMultiUnitRulerDelegate, NMMultiUnitRulerDataSource {
    @IBOutlet weak var ruler: NMMultiUnitRuler?

    var rangeStart = Measurement(value: 0.0, unit: UnitMass.kilograms)
    var rangeLength = Measurement(value: Double(180), unit: UnitMass.kilograms)

    var direction: NMLayerDirection = .horizontal

    var segments = Array<NMSegmentUnit>()

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var lblKg: UILabel!
    @IBOutlet weak var lblPound: UILabel!
    
    @IBOutlet weak var lblIdealWeight: UILabel!
    
    var targetWeight: Double = 65.0
    var targetWeightPounds: Double = 143
    
    var BMI = 0.0
    var idealWeight = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    func initViews() {
        calculateBMI()
        initRulerView()
        calculatePounds()
    }
    
    func initRulerView() {
        addMaskedCorner(view: bottomView, size: 30.0)
        
        ruler?.direction = direction
        ruler?.tintColor = UIColor(red: 0.612, green: 0.800, blue: 0.396, alpha: 1.0)
        segments = self.createSegments()
        ruler?.delegate = self
        ruler?.dataSource = self

        let initialValue = targetWeight
        ruler?.measurement = NSMeasurement(
            doubleValue: Double(initialValue),
            unit: UnitMass.kilograms)
        self.view.layoutSubviews()
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
        UserDefaults.standard.set(targetWeight, forKey: "targetWeight")
        
        //event
        Analytics.logEvent("select_target_weight", parameters: ["target_weight": targetWeight])
        Analytics.setUserProperty(String(targetWeight), forName: "target_weight")

        
        let vc = storyboard?.instantiateViewController(identifier: "ActivityLevelViewController") as! ActivityLevelViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func createSegments() -> Array<NMSegmentUnit> {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .providedUnit
        let cmSegment = NMSegmentUnit(name: "Kilograms", unit: UnitMass.kilograms, formatter: formatter)

        cmSegment.name = "Kilograms"
        cmSegment.unit = UnitMass.kilograms
        
        let cmMarkerTypeMax = NMRangeMarkerType(color: UIColor.red, size: CGSize(width: 1.0, height: 50.0), scale: 10.0)
        cmMarkerTypeMax.labelVisible = true
        
        cmSegment.markerTypes = [NMRangeMarkerType(color: UIColor(red: 0.592, green: 0.592, blue: 0.659, alpha: 1.0), size: CGSize(width: 1.0, height: 35.0), scale: 1.0), NMRangeMarkerType(color: UIColor.darkGray , size: CGSize(width: 1.0, height: 50.0), scale: 5.0)]

        //cmSegment.markerTypes.append(cmMarkerTypeMax)
        cmSegment.markerTypes.last?.labelVisible = false
        return [cmSegment]
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

        func unitForSegmentAtIndex(index: Int) -> NMSegmentUnit {
            return segments[index]
        }
        var numberOfSegments: Int {
            get {
                return segments.count
            }
            set {
            }
        }

        func rangeForUnit(_ unit: Dimension) -> NMRange<Float> {
            let locationConverted = rangeStart.converted(to: unit as! UnitMass)
            let lengthConverted = rangeLength.converted(to: unit as! UnitMass)
            return NMRange<Float>(location: ceilf(Float(locationConverted.value)),
                                  length: ceilf(Float(lengthConverted.value)))
        }

        func styleForUnit(_ unit: Dimension) -> NMSegmentUnitControlStyle {
            let style: NMSegmentUnitControlStyle = NMSegmentUnitControlStyle()
            style.scrollViewBackgroundColor = UIColor.clear
            
            let range = self.rangeForUnit(unit)
            style.textFieldBackgroundColor = UIColor.clear
            //style.textFieldTextColor = UIColor(red: 0.592, green: 0.592, blue: 0.659, alpha: 1.0)
            style.textFieldTextColor = .clear
            return style
        }
    
    func valueChanged(measurement: NSMeasurement) {
        targetWeight = measurement.doubleValue
        calculatePounds()
    }
    
    func calculatePounds() {
        targetWeightPounds = round(targetWeight * 2.2)
        
        lblKg.text = "\(Int(targetWeight)) Kg"
        lblPound.text = "\(Int(targetWeightPounds)) lbs"
    }
    
    func calculateBMI () {
        let height = UserDefaults.standard.double(forKey: "height")
        let currentWeight = UserDefaults.standard.double(forKey: "currentWeight")
        let gender = UserDefaults.standard.string(forKey: "gender")
        
        let heightCm = height/100
        BMI = (currentWeight / ( heightCm * heightCm) )
        
        if gender == "Male" {
            idealWeight = 50 + (0.91 * (height - 152.4) )
        } else {
            idealWeight = 45.5 + (0.91 * (height - 152.4) )
        }
        
        targetWeight = idealWeight
        lblIdealWeight.text = "\(Int(idealWeight)) kg (\(Int(idealWeight*2.2)) lbs)"
    }
}
