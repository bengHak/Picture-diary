//
//  ErrorType.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/18.
//

import Foundation

enum AuthError: Error {
    case serverError
    
    case invalidProviderToken
    case invalidAccessToken
    
    case kakaoLoginError
    case googleLoginError
    case appleLoginError
}
