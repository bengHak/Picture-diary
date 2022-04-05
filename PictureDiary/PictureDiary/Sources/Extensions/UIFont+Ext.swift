//
//  UIFont+Ext.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/12.
//

import UIKit

extension UIFont {
    // MARK: - Default Font
    class func defaultFont(size: CGFloat) -> UIFont! {
        let fontType = UserDefaults.getDefaultFont()
        guard let font = UIFont(name: fontType.rawValue, size: size) else {
            return nil
        }
        return font
    }
    
    public enum Default {
        case body1
        case body2
        
        func font() -> UIFont {
            switch self {
            case .body1:
                return UIFont.defaultFont(size: 16)
            case .body2:
                return UIFont.defaultFont(size: 14)
            }
        }
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
    
    public enum PretendardFont {
        case h1
        case h2
        case subtitle1
        case subtitle2
        case subtitle3
        case body
        case button
        
        func font() -> UIFont {
            switch self {
            case .h1:
                return Pretendard(type: .semiBold, size: 24)
            case .h2:
                return Pretendard(type: .semiBold, size: 16)
            case .subtitle1:
                return Pretendard(type: .medium, size: 18)
            case .subtitle2:
                return Pretendard(type: .semiBold, size: 16)
            case .subtitle3:
                return Pretendard(type: .medium, size: 16)
            case .body:
                return Pretendard(type: .regular, size: 16)
            case .button:
                return Pretendard(type: .semiBold, size: 14)
            }
        }
    }
    
    public enum PretendardType: String {
        case bold = "Pretendard-Bold"
        case semiBold = "Pretendard-SemiBold"
        case regular = "Pretendard-Regular"
        case medium = "Pretendard-Medium"
    }
}
