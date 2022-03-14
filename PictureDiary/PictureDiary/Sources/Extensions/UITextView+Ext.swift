//
//  UITextView+Ext.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/14.
//

import UIKit

extension UITextView {
    func numberOfLine() -> Int {
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = sizeThatFits(size)
        return Int(estimatedSize.height / 36)
    }
}
