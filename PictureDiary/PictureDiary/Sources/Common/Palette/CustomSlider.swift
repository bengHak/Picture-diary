//
//  CustomSlider.swift
//  PictureDiary
//
//  Created by 고병학 on 2022/08/28.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds: CGRect = self.bounds
        bounds = bounds.insetBy(dx: -10, dy: -15)
        return bounds.contains(point)
    }
}
