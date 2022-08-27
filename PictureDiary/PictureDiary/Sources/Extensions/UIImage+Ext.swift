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

    func imageIsEmpty() -> Bool {
        guard let cgImage = self.cgImage,
              let dataProvider = cgImage.dataProvider else {
            return true
        }

        let pixelData = dataProvider.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let imageWidth = Int(self.size.width)
        let imageHeight = Int(self.size.height)
        for x in 0..<imageWidth {
            for y in 0..<imageHeight {
                let pixelIndex = ((imageWidth * y) + x) * 4
                let r = data[pixelIndex]
                let g = data[pixelIndex + 1]
                let b = data[pixelIndex + 2]
                let a = data[pixelIndex + 3]
                if a != 0 {
                    if r != 0 || g != 0 || b != 0 {
                        return false
                    }
                }
            }
        }
        return true
    }
}
