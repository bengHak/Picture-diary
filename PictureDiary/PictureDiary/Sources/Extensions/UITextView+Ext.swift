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
        return Int(estimatedSize.height / (self.font!.lineHeight))
    }

    func setAttributedText(_ text: String, lineSpacing: CGFloat, font: UIFont.DefaultFont = .body1) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        let attributes = [
            NSAttributedString.Key.paragraphStyle: style,
            .font: UIFont.DefaultFont.body1.font()
        ]
        self.attributedText = NSAttributedString(
            string: text,
            attributes: attributes as [NSAttributedString.Key: Any]
        )
    }
}
