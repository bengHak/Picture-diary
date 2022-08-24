//
//  UIColor+Ext.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/14.
//

import UIKit

extension UIColor {

    static func paletteColor(_ type: PaletteColorType) -> UIColor {
        return UIColor(named: type.rawValue)!
    }

    static func appColor(_ type: AppColorType) -> UIColor {
        return UIColor(named: type.rawValue)!
    }
}
