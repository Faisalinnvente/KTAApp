//
//  HeightViewController.swift
//  KTA
//
//  Created by qadeem on 07/02/2021.
//

import UIKit
import NMMultiUnitRuler
import Firebase

class HeightViewController: UIViewController, NMMultiUnitRulerDataSource, NMMultiUnitRulerDelegate {
    @IBOutlet weak var ruler: NMMultiUnitRuler?

    var rangeStart = Measurement(value: 0.0, unit: UnitLength.centimeters)
    var rangeLength = Measurement(value: Double(250), unit: UnitLength.centimeters)

    var direction: NMLayerDirection = .vertical
    var segments = Array<NMSegmentUnit>()
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var lblCm: UILabel!
    @IBOutlet weak var lblFt: UILabel!
    
    var height: Double = 160.0
    var heightFt: Double = 160.0
    var heightInch: Double = 160.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMaskedCorner(view: bottomView, size: 30.0)
        initRulerControl()
        calculateFeetInches()
    }
    
    func initRulerControl() {
        ruler?.direction = direction
        ruler?.tintColor = UIColor(red: 0.612, green: 0.800, blue: 0.396, alpha: 1.0)
        segments = self.createSegments()
        ruler?.delegate = self
        ruler?.dataSource = self

        let initialValue = height
        ruler?.measurement = NSMeasurement(
            doubleValue: Double(initialValue),
            unit: UnitLength.centimeters)
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
        UserDefaults.standard.set(height, forKey: "height")
        
        //event
        Analytics.logEvent("specify_height", parameters: ["user_height": height])
        Analytics.setUserProperty(String(height), forName: "user_height")
        
        let vc = storyboard?.instantiateViewController(identifier: "CurrentWeightViewController") as! CurrentWeightViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    private func createSegments() -> Array<NMSegmentUnit> {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .providedUnit
        let cmSegment = NMSegmentUnit(name: "Centimeters", unit: UnitLength.centimeters, formatter: formatter)

        cmSegment.name = "Centimeters"
        cmSegment.unit = UnitLength.centimeters
        
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
            let locationConverted = rangeStart.converted(to: unit as! UnitLength)
            let lengthConverted = rangeLength.converted(to: unit as! UnitLength)
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
        height = measurement.doubleValue
        calculateFeetInches()
    }
    
    func calculateFeetInches() {
        var length = height/2.54
        heightFt = floor(length/12)
        heightInch = round((length - ( 12*5)))
        
        lblCm.text = "\(height) cm"
        lblFt.text = "\(heightFt) ft \(heightInch) \""
    }
    
}
