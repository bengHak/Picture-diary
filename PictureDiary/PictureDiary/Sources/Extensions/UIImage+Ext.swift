//
//  UIImage+Ext.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/14.
//

import UIKit

extension UIImage {
    func getImageRatio() -> CGFloat {
        let imageRatio = CGFloat(self.size.height / self.size.width)
        return imageRatio
    }
}
