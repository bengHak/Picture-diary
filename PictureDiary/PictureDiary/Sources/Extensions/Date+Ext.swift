//
//  Date+Ext.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/30.
//

import Foundation

extension Date {
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.M.dd EEEE"
        return dateFormatter.string(from: self)
    }
}
