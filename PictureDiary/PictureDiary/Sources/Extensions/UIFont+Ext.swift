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
        let type = UserDefaults.getDefaultFont()
        guard let font = UIFont(name: type.rawValue, size: size) else {
            fatalError(
                    """
                    Failed to load the "\(type.rawValue)" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
            )
        }
        return font
    }
    
    public enum DefaultFont {
        case body1
        case body2
        
        func font() -> UIFont {
            switch self {
            case .body1:
                return defaultFont(size: 16)
            case .body2:
                return defaultFont(size: 14)
            }
        }
    }
    
    public enum DefaultFontType: String {
        case kyobo      = "KyoboHandwriting2020"
        case dulGiMayo  = "Dovemayo-Medium"
        case ubiQueen   = "UhBeeQUEENJ"
        case ubiSulGi   = "UhBeeSeulvely"
        case ubiNamSo   = "UhBeeNamsoyoung"
        case ubiTokyo   = "UhBeeDongKyung"
        case ubiHam     = "UhBeeHamBold"
        case ubiPudding = "UhBeepuding"
    }
    
    // MARK: - Pretendard Font
    class func Pretendard(type: PretendardType, size: CGFloat) -> UIFont! {
        guard let font = UIFont(name: type.rawValue, size: size) else {
            fatalError(
                    """
                    Failed to load the "\(type.rawValue)" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
            )
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
        case bold     = "Pretendard-Bold"
        case semiBold = "Pretendard-SemiBold"
        case regular  = "Pretendard-Regular"
        case medium   = "Pretendard-Medium"
    }
}
