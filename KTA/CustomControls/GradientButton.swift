//
//  GradientButton.swift
//  KTA
//
//  Created by qadeem on 21/02/2021.
//

import UIKit

class GradientButton: UIButton {

    let gradientLayer = CAGradientLayer()
       
       @IBInspectable
       var leftGradientColor: UIColor? {
           didSet {
            setGradient(leftGradientColor: leftGradientColor, rightGradientColor: rightGradientColor)
           }
       }
       
       @IBInspectable
       var rightGradientColor: UIColor? {
           didSet {
            setGradient(leftGradientColor: leftGradientColor, rightGradientColor: rightGradientColor)
           }
       }
       
       private func setGradient(leftGradientColor: UIColor?, rightGradientColor: UIColor?) {
           if let leftGradientColor = leftGradientColor, let rightGradientColor = rightGradientColor {
               gradientLayer.frame = bounds
               gradientLayer.colors = [leftGradientColor.cgColor, rightGradientColor.cgColor]
               gradientLayer.borderColor = layer.borderColor
               gradientLayer.borderWidth = layer.borderWidth
               gradientLayer.cornerRadius = layer.cornerRadius
               gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
               gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
               layer.insertSublayer(gradientLayer, at: 0)
            
                setCornerRadius ()
           } else {
               gradientLayer.removeFromSuperlayer()
           }
       }
    
    func setCornerRadius() {
        layer.masksToBounds = true
        layer.cornerRadius  = 10
    }

}
