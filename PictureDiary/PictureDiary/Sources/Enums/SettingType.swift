//
//  SettingType.swift
//  PictureDiary
//
//  Created by 고병학 on 2022/08/24.
//

import Foundation

enum SettingType: Int {
    case font = 0
    case notice
    case question
    case signout
    case membershipWithdrawal
    case version

    var hasViewController: Bool { self != .version }

    var name: String {
        switch self {
        case .font:
            return "일기장 폰트 설정"
        case .notice:
            return "공지사항"
        case .question:
            return "문의하기"
        case .signout:
            return "로그아웃"
        case .membershipWithdrawal:
            return "회원탈퇴"
        case .version:
            return "버전"
        }
    }
}
