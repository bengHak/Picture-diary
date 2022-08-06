//
//  ASAuthorizationControllerDelegateProxy.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/16.
//

import Foundation
import RxSwift
import RxCocoa
import AuthenticationServices

class ASAuthorizationControllerDelegateProxy: DelegateProxy<ASAuthorizationController,ASAuthorizationControllerDelegate>,
                                              DelegateProxyType,
                                              ASAuthorizationControllerDelegate {
    static func registerKnownImplementations() {
        self.register { (controller) -> ASAuthorizationControllerDelegateProxy in
            ASAuthorizationControllerDelegateProxy(parentObject: controller, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: ASAuthorizationController) -> ASAuthorizationControllerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(
        _ delegate: ASAuthorizationControllerDelegate?,
        to object: ASAuthorizationController
    ) {
        object.delegate = delegate
    }
    
}

extension Reactive where Base: ASAuthorizationController {
    var delegate: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate> {
        return ASAuthorizationControllerDelegateProxy.proxy(for: self.base)
    }
    
    var didCompleteWithAuthorization: Observable<ModelTokenResponse> {
        delegate.methodInvoked(
            #selector(
                ASAuthorizationControllerDelegate
                    .authorizationController(controller:didCompleteWithAuthorization:)
            )
        )
        .map { parameters in
            guard let authorization = parameters[1] as? ASAuthorization,
                  let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let tokenData = credential.identityToken else {
                print("🔴 Failed to sign in with apple")
                return ModelTokenResponse(success: false, token: "")
            }
            return ModelTokenResponse(
                success: true,
                token: String(decoding: tokenData, as: UTF8.self)
            )
        }
    }
}
