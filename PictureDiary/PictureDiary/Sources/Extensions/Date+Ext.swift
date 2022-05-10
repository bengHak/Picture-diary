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
        dateFormatter.dateFormat = "YYYY년 M월 dd일"
        return dateFormatter.string(from: self)
    }
}
