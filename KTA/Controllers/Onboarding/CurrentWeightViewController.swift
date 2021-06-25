//
//  CurrentWeightViewController.swift
//  KTA
//
//  Created by qadeem on 07/02/2021.
//

import UIKit
import NMMultiUnitRuler
import Firebase

class CurrentWeightViewController: UIViewController, NMMultiUnitRulerDelegate, NMMultiUnitRulerDataSource {
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
    
    var currentWeight: Double = 80.0
    var currentWeightPounds: Double = 176.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       initViews()
    }
    
    func initViews() {
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

        let initialValue = currentWeight
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
        UserDefaults.standard.set(currentWeight, forKey: "currentWeight")
        
        //event
        Analytics.logEvent("specify_current_weight", parameters: ["current_weight": currentWeight])
        Analytics.setUserProperty(String(currentWeight), forName: "current_weight")
        
        let vc = storyboard?.instantiateViewController(identifier: "GoalWeightViewController") as! GoalWeightViewController
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
        currentWeight = measurement.doubleValue
        calculatePounds()
    }
    
    func calculatePounds() {
        currentWeightPounds = round(currentWeight * 2.2)
        
        lblKg.text = "\(Int(currentWeight)) Kg"
        lblPound.text = "\(Int(currentWeightPounds)) lbs"
    }
}
