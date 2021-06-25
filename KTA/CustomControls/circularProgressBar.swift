//
//  circularProgressBar.swift
//  KTA
//
//  Created by qadeem on 16/02/2021.
//

import UIKit

@IBDesignable
class circularProgressBar: UIView {

    @IBInspectable var colorCarbs: UIColor? = .gray
    @IBInspectable var colorProtien: UIColor? = .gray
    @IBInspectable var colorFat: UIColor? = .gray
    
    @IBInspectable var ringWidth: CGFloat = 0.0
    
    var carbsPercent: CGFloat = 0.0 {
        didSet { setNeedsDisplay() }
    }
    
    var protienPercent: CGFloat = 0.0 {
        didSet { setNeedsDisplay() }
    }
    
    var fatPercent: CGFloat = 0.0 {
        didSet { setNeedsDisplay() }
    }
    
    private let carbsLayer = CAShapeLayer()
    private let protienLayer = CAShapeLayer()
    private let fatLayer = CAShapeLayer()
    
    private let backgroundMask = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        backgroundMask.lineWidth = ringWidth
        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = UIColor.black.cgColor
        layer.mask = backgroundMask

        carbsLayer.lineWidth = ringWidth
        carbsLayer.fillColor = nil
        
        protienLayer.lineWidth = ringWidth
        protienLayer.fillColor = nil
        
        fatLayer.lineWidth = ringWidth
        fatLayer.fillColor = nil
        
        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)
    }

    override func draw(_ rect: CGRect) {
        setupLayers()
        
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: ringWidth / 2, dy: ringWidth / 2))
        backgroundMask.path = circlePath.cgPath

        carbsLayer.path = circlePath.cgPath
        carbsLayer.lineCap = .round
        carbsLayer.strokeStart = 0
        carbsLayer.strokeEnd = carbsPercent
        carbsLayer.strokeColor = colorCarbs?.cgColor
        layer.addSublayer(carbsLayer)
        
        protienLayer.path = circlePath.cgPath
        protienLayer.lineCap = .round
        protienLayer.strokeStart = carbsPercent
        protienLayer.strokeEnd = carbsPercent + protienPercent
        protienLayer.strokeColor = colorProtien?.cgColor
        layer.addSublayer(protienLayer)
        
        
        fatLayer.path = circlePath.cgPath
        fatLayer.lineCap = .round
        fatLayer.strokeStart = carbsPercent + protienPercent
        fatLayer.strokeEnd = carbsPercent + protienPercent + fatPercent
        fatLayer.strokeColor = colorFat?.cgColor
        layer.addSublayer(fatLayer)
    }

}
