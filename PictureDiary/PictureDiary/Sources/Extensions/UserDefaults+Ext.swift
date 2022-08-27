//
//  UserDefaults+Ext.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/05.
//

import Foundation
import UIKit

extension UserDefaults {
    static let defaultFontStringKey = "defaultFont"

    class func getDefaultFont() -> UIFont.DefaultFontType {
        let fontString = UserDefaults.standard.string(forKey: Self.defaultFontStringKey) ?? ""
        return UIFont.DefaultFontType(rawValue: fontString) ?? UIFont.DefaultFontType.ubiSulGi
    }

    class func setDefaultFont(_ font: UIFont.DefaultFontType) {
        UserDefaults.standard.set(font.rawValue, forKey: Self.defaultFontStringKey)
    }
}
