//
//  CustomUISlider.swift
//  KTA
//
//  Created by qadeem on 08/02/2021.
//

import Foundation
import UIKit

class CustomUISlider: UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
         let point = CGPoint(x: bounds.minX, y: bounds.midY)
         return CGRect(origin: point, size: CGSize(width: bounds.width, height: 20))
     }
}
