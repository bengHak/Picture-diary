//
//  ErrorType.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/18.
//

import Foundation

enum AuthError: Error {
    case serverSignInError
    case serverSignUpError
    
    case invalidProviderToken
    case invalidAccessToken
    
    case kakaoLoginError
    case googleLoginError
    case appleLoginError
}


enum DiaryError: Error {
    case uploadImageError
    case uploadDiaryError
    case fetchDiaryError
    case fetchDiaryListError
}
