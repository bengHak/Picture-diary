//
//  GoogleAuth.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/14.
//

import Foundation
import RxSwift
import GoogleSignIn
import UIKit

struct GoogleAuth: OAuthProtocol {
    func authorize() -> Observable<ModelTokenResponse> {
        let signInConfig = GIDConfiguration(clientID: (Bundle.main.infoDictionary?["GOOGLE_API_CLIENT_ID"] as? String) ?? "")
        return Observable.create { observer in
            GIDSignIn.sharedInstance.signIn(
                with: signInConfig,
                presenting: UIApplication.shared.windows.first!.rootViewController!
            ) { user, error in
                guard error == nil, let user = user else {
                    observer.onError(AuthError.googleLoginError)
                    return
                }
                user.authentication.do { authentication, error in
                    guard error == nil,
                          let authentication = authentication else {
                        observer.onError(AuthError.googleLoginError)
                        return
                    }
                    observer.onNext(ModelTokenResponse(success: true, token: authentication.idToken))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
