//
//  UILabel+Ext.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/05.
//

import Foundation
import UIKit

extension UILabel {
    func setTextWithLineHeight(text: String?, fontSize: CGFloat, fontWeight: UIFont.Weight, lineHeight: CGFloat) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .font: UIFont.Pretendard(type: .bold, size: fontSize)!,
                .baselineOffset: (lineHeight - font.lineHeight) / 2 + font.descender
            ]
                
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
}
