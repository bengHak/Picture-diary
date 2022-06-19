//
//  ModelAuthResponse.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/17.
//

import Foundation

/// 로그인, 로그아웃 리스폰스
/// - accessToken
struct ModelAuthResponse: Decodable {
    var accessToken: String?
}
