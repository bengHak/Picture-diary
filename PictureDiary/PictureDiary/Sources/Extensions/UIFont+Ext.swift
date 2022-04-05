//
//  UIFont+Ext.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/12.
//

import UIKit

extension UIFont {
    // MARK: - Default Font
    class func defaultFont(type: DefaultFontType, size: CGFloat) -> UIFont! {
        guard let font = UIFont(name: type.rawValue, size: size) else {
            return nil
        }
        return font
    }
    
    public enum DefaultFontType: String {
        case kyobo = "KyoboHandwriting2020pdy"
        case dulGiMayo = "dovemayo"
        case ubiQueen = "UhBee-QUEEN-J"
        case ubiSulGi = "UhBee-Seulvely-2"
        case ubiNamSo = "UhBee-namsoyoung"
        case ubiTokyo = "UhBee-DongKyung"
        case ubiHam = "UhBee-Ham-Bold"
        case ubiPudding = "UhBee-puding"
    }
    
    // MARK: - Pretendard Font
    class func Pretendard(type: PretendardType, size: CGFloat) -> UIFont! {
        guard let font = UIFont(name: type.rawValue, size: size) else {
            return nil
        }
        return font
    }
    
    public enum PretendardType: String {
        case bold = "Pretendard-Bold"
        case semiBold = "Pretendard-SemiBold"
        case regular = "Pretendard-Regular"
        case medium = "Pretendard-Medium"
    }
}
