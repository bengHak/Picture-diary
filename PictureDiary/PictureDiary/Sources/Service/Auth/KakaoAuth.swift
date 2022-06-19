//
//  KakaoAuth.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/14.
//

import Foundation
import RxSwift
import KakaoSDKUser
import RxKakaoSDKUser

struct KakaoAuth: OAuthProtocol {
    func authorize() -> Observable<ModelTokenResponse> {
        if UserApi.isKakaoTalkLoginAvailable() {
            return UserApi.shared.rx.loginWithKakaoTalk()
                .map { ModelTokenResponse(success: true, token: $0.accessToken) }
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount()
                .map { ModelTokenResponse(success: true, token: $0.accessToken) }
        }
    }
}
