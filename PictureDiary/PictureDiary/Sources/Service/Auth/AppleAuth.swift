//
//  AppleAuth.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/14.
//

import Foundation
import RxSwift
import AuthenticationServices

struct AppleAuth: OAuthProtocol {
    func authorize() -> Observable<ModelTokenResponse> {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.performRequests()
        return controller.rx.didCompleteWithAuthorization
    }
}
