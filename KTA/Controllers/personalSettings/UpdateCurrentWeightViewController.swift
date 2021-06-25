//
//  UpdateCurrentWeightViewController.swift
//  KTA
//
//  Created by qadeem on 18/03/2021.
//

import UIKit
import NMMultiUnitRuler
import Firebase

class UpdateCurrentWeightViewController: UIViewController, NMMultiUnitRulerDelegate, NMMultiUnitRulerDataSource {
    @IBOutlet weak var ruler: NMMultiUnitRuler?
    @IBOutlet weak var btnSave: UIButton!

    var rangeStart = Measurement(value: 0.0, unit: UnitMass.kilograms)
    var rangeLength = Measurement(value: Double(180), unit: UnitMass.kilograms)

    var direction: NMLayerDirection = .horizontal

    var segments = Array<NMSegmentUnit>()
    
    var currentWeight: Double = 90.0

    override func viewDidLoad() {
        super.viewDidLoad()

        Analytics.logEvent("view_update_starting_weight", parameters: nil)
        initViews()
    }
    
    func initViews() {
        btnSave.layer.cornerRadius = 20.0
        currentWeight = UserDefaults.standard.double(forKey: "currentWeight")
        
        initRulerView()
    }
    
    func initRulerView() {
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
        style.textFieldTextColor = UIColor(red: 0.592, green: 0.592, blue: 0.659, alpha: 1.0)
        return style
    }
    
    func valueChanged(measurement: NSMeasurement) {
            currentWeight = measurement.doubleValue
    }
    
    @IBAction func saveStartingWeigh(_ sender: Any) {
        UserDefaults.standard.set(currentWeight, forKey: "currentWeight")
        Analytics.logEvent("update_starting_weight", parameters: ["current_weight": currentWeight])
        self.navigationController?.popViewController(animated: true)
    }
    
}
